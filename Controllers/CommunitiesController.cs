using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Data.SqlClient;  
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using interpolapi.Data;
using interpolapi.Models;

namespace interpolapi.Controllers
{
    public class CommunitiesController : Controller
    {
        private readonly InterpolContext _context;
        private readonly IConfiguration _configuration;
        private string? databaseConnection;

        public CommunitiesController(InterpolContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
            databaseConnection = _configuration.GetConnectionString("InterpolDb");
        }

        // GET: Communities
        public async Task<ActionResult<IEnumerable<Community>>> Index()
        {
            if (_context.Communities == null)
            {
                return NotFound();
            }
            IList<Community> communities = new List<Community>();
            await using (SqlConnection connection = new SqlConnection(databaseConnection))
            {
                SqlCommand command = new SqlCommand("interpol.getCommunities", connection);
                command.Connection.Open();
                SqlDataReader reader = command.ExecuteReader();
                while(reader.Read())
                {
                    Community community = new Community()
                    {
                        CommunityId = reader["community_id"].ToString(),
                        CommunityName = reader["community_name"].ToString(),
                        CommunityDescription = reader["community_description"].ToString(),
                        // DateCreated = reader.GetDateTime(3),
                        User = new InterpolUser() { 
                            UserName = reader["user_name"].ToString(), 
                            UserId = reader["user_id"].ToString(), 
                            ImageLink = reader["image_link"].ToString()
                        }
                    };
                    if (!Convert.IsDBNull(reader["profile_pic"])) 
                    {
                        community.User.ImageData = (byte[])reader["profile_pic"];
                    }
                    if (!Convert.IsDBNull(reader["community_pic"])) 
                    {
                        community.ImageData = (byte[])reader["community_pic"];
                    }
                    communities.Add(community);
                }
                return communities.ToList();
            }
        }

        // GET: Communities/Details/5
        public async Task<ActionResult<Community>> Details(string id)
        {
            if (id == null || _context.Communities == null)
            {
                return NotFound();
            }

            await using (SqlConnection connection = new SqlConnection(databaseConnection))
            {
                SqlCommand command = new SqlCommand("interpol.getSingleCommunity", connection);
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@pCommunityId", id);
                command.Connection.Open();
                SqlDataReader reader = command.ExecuteReader();
                Community community = new Community();
                while(reader.Read())
                {
                    {
                        community.CommunityId = reader["community_id"].ToString();
                        community.CommunityName = reader["community_name"].ToString();
                        community.CommunityDescription = reader["community_description"].ToString();
                        community.DateCreated = (DateTime)reader["date_created"];
                        community.ImageLink = reader["community_link"].ToString();
                        community.User = new InterpolUser() { 
                            UserName = reader["user_name"].ToString(), 
                            UserId = reader["user_id"].ToString(),
                            ImageLink = reader["image_link"].ToString()
                        };
                    };
                    if (!Convert.IsDBNull(reader["profile_pic"])) 
                    {
                        community.User.ImageData = (byte[])reader["profile_pic"];
                    }
                    if (!Convert.IsDBNull(reader["community_pic"])) 
                    {
                        community.ImageData = (byte[])reader["community_pic"];
                    }
                }
                return community;
            } 
        }

        // GET: Communities/Create
        public IActionResult Create()
        {
            ViewData["PhotoId"] = new SelectList(_context.Photos, "PhotoId", "PhotoId");
            ViewData["UserId"] = new SelectList(_context.InterpolUsers, "UserId", "UserId");
            return View();
        }

        // POST: Communities/Create
        // To protect from overcommunitying attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("CommunityId,CommunityName,CommunityDescription,DateCreated,UserId,PhotoId")] Community community)
        {
            if (ModelState.IsValid)
            {
                _context.Add(community);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["PhotoId"] = new SelectList(_context.Photos, "PhotoId", "PhotoId", community.PhotoId);
            ViewData["UserId"] = new SelectList(_context.InterpolUsers, "UserId", "UserId", community.UserId);
            return View(community);
        }

        // GET: Communities/Edit/5
        public async Task<IActionResult> Edit(string id)
        {
            if (id == null || _context.Communities == null)
            {
                return NotFound();
            }

            var community = await _context.Communities.FindAsync(id);
            if (community == null)
            {
                return NotFound();
            }
            ViewData["PhotoId"] = new SelectList(_context.Photos, "PhotoId", "PhotoId", community.PhotoId);
            ViewData["UserId"] = new SelectList(_context.InterpolUsers, "UserId", "UserId", community.UserId);
            return View(community);
        }

        // POST: Communities/Edit/5
        // To protect from overcommunitying attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, [Bind("CommunityId,CommunityName,CommunityDescription,DateCreated,UserId,PhotoId")] Community community)
        {
            if (id != community.CommunityId)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(community);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!CommunityExists(community.CommunityId))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            ViewData["PhotoId"] = new SelectList(_context.Photos, "PhotoId", "PhotoId", community.PhotoId);
            ViewData["UserId"] = new SelectList(_context.InterpolUsers, "UserId", "UserId", community.UserId);
            return View(community);
        }

        // GET: Communities/Delete/5
        public async Task<IActionResult> Delete(string id)
        {
            if (id == null || _context.Communities == null)
            {
                return NotFound();
            }

            var community = await _context.Communities
                .Include(c => c.Photo)
                .Include(c => c.User)
                .FirstOrDefaultAsync(m => m.CommunityId == id);
            if (community == null)
            {
                return NotFound();
            }

            return View(community);
        }

        // POST: Communities/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            if (_context.Communities == null)
            {
                return Problem("Entity set 'InterpolContext.Communities'  is null.");
            }
            var community = await _context.Communities.FindAsync(id);
            if (community != null)
            {
                _context.Communities.Remove(community);
            }
            
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool CommunityExists(string id)
        {
          return (_context.Communities?.Any(e => e.CommunityId == id)).GetValueOrDefault();
        }
    }
}
