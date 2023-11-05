using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using interpolapi.Data;
using interpolapi.Models;

namespace interpolapi.Controllers
{
    public class ChannelCommentsController : Controller
    {
        private readonly InterpolContext _context;

        public ChannelCommentsController(InterpolContext context)
        {
            _context = context;
        }

        // GET: ChannelComments
        public async Task<IActionResult> Index()
        {
            var interpolContext = _context.ChannelComments.Include(c => c.Channel).Include(c => c.Photo);
            return View(await interpolContext.ToListAsync());
        }

        // GET: ChannelComments/Details/5
        public async Task<IActionResult> Details(string id)
        {
            if (id == null || _context.ChannelComments == null)
            {
                return NotFound();
            }

            var channelComment = await _context.ChannelComments
                .Include(c => c.Channel)
                .Include(c => c.Photo)
                .FirstOrDefaultAsync(m => m.CommentId == id);
            if (channelComment == null)
            {
                return NotFound();
            }

            return View(channelComment);
        }

        // GET: ChannelComments/Create
        public IActionResult Create()
        {
            ViewData["ChannelId"] = new SelectList(_context.Channels, "ChannelId", "ChannelId");
            ViewData["PhotoId"] = new SelectList(_context.Photos, "PhotoId", "PhotoId");
            return View();
        }

        // POST: ChannelComments/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("CommentId,Content,DateCreated,ChannelId,PhotoId")] ChannelComment channelComment)
        {
            if (ModelState.IsValid)
            {
                _context.Add(channelComment);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["ChannelId"] = new SelectList(_context.Channels, "ChannelId", "ChannelId", channelComment.ChannelId);
            ViewData["PhotoId"] = new SelectList(_context.Photos, "PhotoId", "PhotoId", channelComment.PhotoId);
            return View(channelComment);
        }

        // GET: ChannelComments/Edit/5
        public async Task<IActionResult> Edit(string id)
        {
            if (id == null || _context.ChannelComments == null)
            {
                return NotFound();
            }

            var channelComment = await _context.ChannelComments.FindAsync(id);
            if (channelComment == null)
            {
                return NotFound();
            }
            ViewData["ChannelId"] = new SelectList(_context.Channels, "ChannelId", "ChannelId", channelComment.ChannelId);
            ViewData["PhotoId"] = new SelectList(_context.Photos, "PhotoId", "PhotoId", channelComment.PhotoId);
            return View(channelComment);
        }

        // POST: ChannelComments/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, [Bind("CommentId,Content,DateCreated,ChannelId,PhotoId")] ChannelComment channelComment)
        {
            if (id != channelComment.CommentId)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(channelComment);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ChannelCommentExists(channelComment.CommentId))
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
            ViewData["ChannelId"] = new SelectList(_context.Channels, "ChannelId", "ChannelId", channelComment.ChannelId);
            ViewData["PhotoId"] = new SelectList(_context.Photos, "PhotoId", "PhotoId", channelComment.PhotoId);
            return View(channelComment);
        }

        // GET: ChannelComments/Delete/5
        public async Task<IActionResult> Delete(string id)
        {
            if (id == null || _context.ChannelComments == null)
            {
                return NotFound();
            }

            var channelComment = await _context.ChannelComments
                .Include(c => c.Channel)
                .Include(c => c.Photo)
                .FirstOrDefaultAsync(m => m.CommentId == id);
            if (channelComment == null)
            {
                return NotFound();
            }

            return View(channelComment);
        }

        // POST: ChannelComments/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            if (_context.ChannelComments == null)
            {
                return Problem("Entity set 'InterpolContext.ChannelComments'  is null.");
            }
            var channelComment = await _context.ChannelComments.FindAsync(id);
            if (channelComment != null)
            {
                _context.ChannelComments.Remove(channelComment);
            }
            
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool ChannelCommentExists(string id)
        {
          return (_context.ChannelComments?.Any(e => e.CommentId == id)).GetValueOrDefault();
        }
    }
}
