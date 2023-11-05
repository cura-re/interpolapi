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
    public class ChatsController : Controller
    {
        private readonly InterpolContext _context;

        public ChatsController(InterpolContext context)
        {
            _context = context;
        }

        // GET: Chats
        public async Task<IActionResult> Index()
        {
            var interpolContext = _context.Chats.Include(c => c.Ai).Include(c => c.User);
            return View(await interpolContext.ToListAsync());
        }

        // GET: Chats/Details/5
        public async Task<IActionResult> Details(string id)
        {
            if (id == null || _context.Chats == null)
            {
                return NotFound();
            }

            var chat = await _context.Chats
                .Include(c => c.Ai)
                .Include(c => c.User)
                .FirstOrDefaultAsync(m => m.ChatId == id);
            if (chat == null)
            {
                return NotFound();
            }

            return View(chat);
        }

        // GET: Chats/Create
        public IActionResult Create()
        {
            ViewData["AiId"] = new SelectList(_context.ArtificialIntelligences, "AiId", "AiId");
            ViewData["UserId"] = new SelectList(_context.InterpolUsers, "UserId", "UserId");
            return View();
        }

        // POST: Chats/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("ChatId,ChatTitle,DateCreated,AiId,UserId")] Chat chat)
        {
            if (ModelState.IsValid)
            {
                _context.Add(chat);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["AiId"] = new SelectList(_context.ArtificialIntelligences, "AiId", "AiId", chat.AiId);
            ViewData["UserId"] = new SelectList(_context.InterpolUsers, "UserId", "UserId", chat.UserId);
            return View(chat);
        }

        // GET: Chats/Edit/5
        public async Task<IActionResult> Edit(string id)
        {
            if (id == null || _context.Chats == null)
            {
                return NotFound();
            }

            var chat = await _context.Chats.FindAsync(id);
            if (chat == null)
            {
                return NotFound();
            }
            ViewData["AiId"] = new SelectList(_context.ArtificialIntelligences, "AiId", "AiId", chat.AiId);
            ViewData["UserId"] = new SelectList(_context.InterpolUsers, "UserId", "UserId", chat.UserId);
            return View(chat);
        }

        // POST: Chats/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, [Bind("ChatId,ChatTitle,DateCreated,AiId,UserId")] Chat chat)
        {
            if (id != chat.ChatId)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(chat);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ChatExists(chat.ChatId))
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
            ViewData["AiId"] = new SelectList(_context.ArtificialIntelligences, "AiId", "AiId", chat.AiId);
            ViewData["UserId"] = new SelectList(_context.InterpolUsers, "UserId", "UserId", chat.UserId);
            return View(chat);
        }

        // GET: Chats/Delete/5
        public async Task<IActionResult> Delete(string id)
        {
            if (id == null || _context.Chats == null)
            {
                return NotFound();
            }

            var chat = await _context.Chats
                .Include(c => c.Ai)
                .Include(c => c.User)
                .FirstOrDefaultAsync(m => m.ChatId == id);
            if (chat == null)
            {
                return NotFound();
            }

            return View(chat);
        }

        // POST: Chats/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            if (_context.Chats == null)
            {
                return Problem("Entity set 'InterpolContext.Chats'  is null.");
            }
            var chat = await _context.Chats.FindAsync(id);
            if (chat != null)
            {
                _context.Chats.Remove(chat);
            }
            
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool ChatExists(string id)
        {
          return (_context.Chats?.Any(e => e.ChatId == id)).GetValueOrDefault();
        }
    }
}
