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
    public class UsersController : Controller
    {
        private readonly InterpolContext _context;
        private readonly IConfiguration _configuration;
        private string? databaseConnection;

        public UsersController(InterpolContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
            databaseConnection = _configuration.GetConnectionString("InterpolDb");
        }

        // GET: Users
        public async Task<ActionResult<IEnumerable<InterpolUser>>> Index()
        {
            if (_context.InterpolUsers == null)
            {
                return NotFound();
            }
            IList<InterpolUser> usersList = new List<InterpolUser>(); 
            await using (SqlConnection connection = new SqlConnection(databaseConnection))
            {
                SqlCommand command = new SqlCommand("interpol.getUsers", connection);
                command.Connection.Open();
                SqlDataReader reader = command.ExecuteReader();
                while(reader.Read())
                {
                    InterpolUser user = new InterpolUser()
                    {
                        UserId = reader["user_id"].ToString()  ?? "",
                        UserName = reader["user_name"].ToString() ?? "",
                        FirstName = reader["first_name"].ToString() ?? "",
                        // DateOfBirth = Convert.ToDateTime(reader["date_of_birth"]),
                        // DateCreated = (DateTime)reader["date_created"],
                        // LastName = reader["last_name"].ToString(),
                        About = reader["about"].ToString() ?? "",
                        PhotoId = reader["photo_id"].ToString() ?? "",
                        ImageLink = reader["image_link"].ToString() ?? ""
                    };
                    if (!Convert.IsDBNull(reader["image_data"])) 
                    {
                        user.ImageData = (byte[])reader["image_data"];
                    }
                    usersList.Add(user);
                }
            } 
            return usersList.ToList();
        }

        // GET: Users/Username/username
        public async Task<ActionResult<List<InterpolUser>>> Username(string? id)
        {
            if (id == null || _context.InterpolUsers == null)
            {
                return NotFound();
            }

            IList<InterpolUser> users = new List<InterpolUser>();

            await using (SqlConnection connection = new SqlConnection(databaseConnection))
            {
                SqlCommand command = new SqlCommand("interpol.getSingleUserName", connection);
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@pUserName", id);
                command.Connection.Open();
                SqlDataReader reader = command.ExecuteReader();
                InterpolUser user = new InterpolUser();
                IList<Community> communities = new List<Community>();
                IList<Post> posts = new List<Post>();
                while(reader.Read())
                {
                    if (reader["community_id"] != DBNull.Value)
                    {
                        Community community = new Community()
                        {
                            CommunityId = reader["community_id"].ToString() ?? "",
                            CommunityName = reader["community_name"].ToString() ?? "",
                            CommunityDescription = reader["community_description"].ToString() ?? "",
                            ImageLink = reader["community_link"].ToString() ?? "",
                        };
                        if (!Convert.IsDBNull(reader["community_pic"])) 
                        {
                            community.ImageData = (byte[])reader["community_pic"];
                        }
                        communities.Add(community);
                    }
                    if (reader["post_id"] != DBNull.Value)
                    {
                        Post post = new Post()
                        {
                            PostId = reader["post_id"].ToString() ?? "",
                            PostContent = reader["post_content"].ToString() ?? "",
                            // DateCreated = (DateTime)reader["date_created"],
                            // PhotoId = reader["photo_id"].ToString(),
                            ImageLink = reader["post_link"].ToString() ?? "",
                        };
                        if (!Convert.IsDBNull(reader["post_pic"])) 
                        {
                            post.ImageData = (byte[])reader["post_pic"];
                        }
                        posts.Add(post);
                    }
                    user.UserId = reader["user_id"].ToString() ?? "";
                    user.UserName = reader["user_name"].ToString() ?? "";
                    user.FirstName = reader["first_name"].ToString() ?? "";
                    // user.LastName = reader["last_name"].ToString();
                    user.About = reader["about"].ToString() ?? "";
                    user.PhotoId = reader["photo_id"].ToString() ?? "";
                    user.ImageLink = reader["image_link"].ToString() ?? "";
                    if (!Convert.IsDBNull(reader["image_data"])) 
                    {
                        user.ImageData = (byte[])reader["image_data"];
                    }
                    users.Add(user);
                }
                return users.ToList();
            } 
        }

        // GET: Users/id/id
        public async Task<ActionResult<InterpolUser>> Id(string? id)
        {
            if (id  == null || _context.InterpolUsers == null)
            {
                return NotFound();
            }

            await using (SqlConnection connection = new SqlConnection(databaseConnection))
            {
                SqlCommand command = new SqlCommand("interpol.getSingleUser", connection);
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@pUserId", id);
                command.Connection.Open();
                SqlDataReader reader = command.ExecuteReader();
                InterpolUser user = new InterpolUser();
                IList<Post> posts = new List<Post>();
                IList<Community> communities = new List<Community>();
                while(reader.Read())
                {
                    if (reader["community_id"] != DBNull.Value)
                    {
                        Community community = new Community()
                        {
                            CommunityId = reader["community_id"].ToString() ?? "",
                            CommunityName = reader["community_name"].ToString() ?? "",
                            CommunityDescription = reader["community_description"].ToString() ?? "",
                            ImageLink = reader["community_link"].ToString() ?? "",
                        };
                        if (!Convert.IsDBNull(reader["community_pic"])) 
                        {
                            community.ImageData = (byte[])reader["community_pic"];
                        }
                        communities.Add(community);
                    }
                    if (reader["post_id"] != DBNull.Value)
                    {
                        Post post = new Post()
                        {
                            PostId = reader["post_id"].ToString() ?? "",
                            PostContent = reader["post_content"].ToString() ?? "",
                            // DateCreated = (DateTime)reader["date_created"],
                            // PhotoId = reader["photo_id"].ToString(),
                            ImageLink = reader["post_link"].ToString() ?? "",
                        };
                        if (!Convert.IsDBNull(reader["post_pic"])) 
                        {
                            post.ImageData = (byte[])reader["post_pic"];
                        }
                        posts.Add(post);
                    }
                    user.UserId = reader["user_id"].ToString() ?? "";
                    user.UserName = reader["user_name"].ToString() ?? "";
                    user.FirstName = reader["first_name"].ToString() ?? "";
                    // user.LastName = reader["last_name"].ToString();
                    user.About = reader["about"].ToString() ?? "";
                    user.PhotoId = reader["photo_id"].ToString() ?? "";
                    user.ImageLink = reader["image_link"].ToString() ?? "";
                    user.Posts = posts;
                    user.Communities = communities;
                    if (!Convert.IsDBNull(reader["image_data"])) 
                    {
                        user.ImageData = (byte[])reader["image_data"];
                    }
                }
                return user;
            } 
        }

        // POST: User/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<InterpolUser> Create([FromForm] InterpolUser user)
        {
            await using (SqlConnection connection = new SqlConnection(databaseConnection))
            {
                SqlCommand command = new SqlCommand("interpol.addUser", connection);
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@pUserName", user.UserName);
                command.Parameters.AddWithValue("@pFirstName", user.FirstName);
                command.Parameters.AddWithValue("@pLastName", user.LastName);
                command.Parameters.AddWithValue("@pDateOfBirth", user.DateOfBirth);
                command.Parameters.AddWithValue("@pEmailAddress", user.EmailAddress);
                // command.Parameters.AddWithValue("@pPassword", user.Password);
                command.Parameters.AddWithValue("@pAbout", user.About);
                command.Parameters.AddWithValue("@ImageLink", user.ImageLink);
                command.Parameters.AddWithValue("@ImageData", user.ImageData);
                command.Connection.Open();
                command.ExecuteNonQuery();
                return user;
            } 
        }

        [HttpPut]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult<InterpolUser>> Update(string id, [FromForm] InterpolUser user)
        {
            if (id != user.UserId)
            {
                return NotFound();
            }
            if (HttpContext.Request.Cookies["user"] != null)
            {
                string userId = HttpContext.Request.Cookies["user"] ?? "";
                await using (SqlConnection connection = new SqlConnection(databaseConnection))
                {
                    SqlCommand command = new SqlCommand("interpol.updateUser", connection);
                    command.CommandType = System.Data.CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@pUseId", userId);
                    command.Parameters.AddWithValue("@pUserName", user.UserName);
                    command.Parameters.AddWithValue("@pFirstName", user.FirstName);
                    command.Parameters.AddWithValue("@pLastName", user.LastName);
                    command.Parameters.AddWithValue("@pDateOfBirth", user.DateOfBirth);
                    command.Parameters.AddWithValue("@pEmailAddress", user.EmailAddress);
                    // command.Parameters.AddWithValue("@pPassword", user.Password);
                    command.Parameters.AddWithValue("@pAbout", user.About);
                    command.Parameters.AddWithValue("@ImageLink", user.ImageLink);
                    command.Parameters.AddWithValue("@ImageData", user.ImageData);
                    command.Connection.Open();
                    command.ExecuteNonQuery();
                    return user;
                } 
            }
            return NotFound();
        }

        // POST: Users/Delete/5
        [HttpDelete, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            if (_context.InterpolUsers == null)
            {
                return Problem("Entity set 'InterpolContext.InterpolUsers'  is null.");
            }

            if (HttpContext.Request.Cookies["user"] != null)
            {
                string userId = HttpContext.Request.Cookies["user"] ?? "";
                await using (SqlConnection connection = new SqlConnection(databaseConnection))
                {
                    SqlCommand command = new SqlCommand("interpol.deleteUser", connection);
                    command.CommandType = System.Data.CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@pUserId", userId);
                    command.Parameters.AddWithValue("@pPassword", id);
                    command.Connection.Open();
                    command.ExecuteNonQuery();
                    return Problem("Entity set 'InterpolContext.InterpolUsers'  is null.");
                } 
            }
            return NotFound();
        }

        private bool InterpolUserExists(string id)
        {
          return (_context.InterpolUsers?.Any(e => e.UserId == id)).GetValueOrDefault();
        }
    }
}
