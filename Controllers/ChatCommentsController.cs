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
    public class ChatCommentsController : Controller
    {
        private readonly InterpolContext _context;

        public ChatCommentsController(InterpolContext context)
        {
            _context = context;
        }

        // GET: ChatComments
        public async Task<IActionResult> Index()
        {
            var interpolContext = _context.ChatComments.Include(c => c.Chat).Include(c => c.Photo);
            return View(await interpolContext.ToListAsync());
        }

        // GET: ChatComments/Details/5
        public async Task<IActionResult> Details(string id)
        {
            if (id == null || _context.ChatComments == null)
            {
                return NotFound();
            }

            var chatComment = await _context.ChatComments
                .Include(c => c.Chat)
                .Include(c => c.Photo)
                .FirstOrDefaultAsync(m => m.CommentId == id);
            if (chatComment == null)
            {
                return NotFound();
            }

            return View(chatComment);
        }

        // GET: ChatComments/Create
        public IActionResult Create()
        {
            ViewData["ChatId"] = new SelectList(_context.Chats, "ChatId", "ChatId");
            ViewData["PhotoId"] = new SelectList(_context.Photos, "PhotoId", "PhotoId");
            return View();
        }

        // POST: ChatComments/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("CommentId,Content,DateCreated,ChatId,PhotoId")] ChatComment chatComment)
        {
            if (ModelState.IsValid)
            {
                _context.Add(chatComment);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["ChatId"] = new SelectList(_context.Chats, "ChatId", "ChatId", chatComment.ChatId);
            ViewData["PhotoId"] = new SelectList(_context.Photos, "PhotoId", "PhotoId", chatComment.PhotoId);
            return View(chatComment);
        }

        // GET: ChatComments/Edit/5
        public async Task<IActionResult> Edit(string id)
        {
            if (id == null || _context.ChatComments == null)
            {
                return NotFound();
            }

            var chatComment = await _context.ChatComments.FindAsync(id);
            if (chatComment == null)
            {
                return NotFound();
            }
            ViewData["ChatId"] = new SelectList(_context.Chats, "ChatId", "ChatId", chatComment.ChatId);
            ViewData["PhotoId"] = new SelectList(_context.Photos, "PhotoId", "PhotoId", chatComment.PhotoId);
            return View(chatComment);
        }

        // POST: ChatComments/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, [Bind("CommentId,Content,DateCreated,ChatId,PhotoId")] ChatComment chatComment)
        {
            if (id != chatComment.CommentId)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(chatComment);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ChatCommentExists(chatComment.CommentId))
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
            ViewData["ChatId"] = new SelectList(_context.Chats, "ChatId", "ChatId", chatComment.ChatId);
            ViewData["PhotoId"] = new SelectList(_context.Photos, "PhotoId", "PhotoId", chatComment.PhotoId);
            return View(chatComment);
        }

        // GET: ChatComments/Delete/5
        public async Task<IActionResult> Delete(string id)
        {
            if (id == null || _context.ChatComments == null)
            {
                return NotFound();
            }

            var chatComment = await _context.ChatComments
                .Include(c => c.Chat)
                .Include(c => c.Photo)
                .FirstOrDefaultAsync(m => m.CommentId == id);
            if (chatComment == null)
            {
                return NotFound();
            }

            return View(chatComment);
        }

        // POST: ChatComments/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            if (_context.ChatComments == null)
            {
                return Problem("Entity set 'InterpolContext.ChatComments'  is null.");
            }
            var chatComment = await _context.ChatComments.FindAsync(id);
            if (chatComment != null)
            {
                _context.ChatComments.Remove(chatComment);
            }
            
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool ChatCommentExists(string id)
        {
          return (_context.ChatComments?.Any(e => e.CommentId == id)).GetValueOrDefault();
        }
    }
}
