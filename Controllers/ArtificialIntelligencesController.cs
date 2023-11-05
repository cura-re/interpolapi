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
    public class ArtificialIntelligencesController : Controller
    {
        private readonly InterpolContext _context;

        public ArtificialIntelligencesController(InterpolContext context)
        {
            _context = context;
        }

        // GET: ArtificialIntelligences
        public async Task<IActionResult> Index()
        {
            var interpolContext = _context.ArtificialIntelligences.Include(a => a.Photo).Include(a => a.User);
            return View(await interpolContext.ToListAsync());
        }

        // GET: ArtificialIntelligences/Details/5
        public async Task<IActionResult> Details(string id)
        {
            if (id == null || _context.ArtificialIntelligences == null)
            {
                return NotFound();
            }

            var artificialIntelligence = await _context.ArtificialIntelligences
                .Include(a => a.Photo)
                .Include(a => a.User)
                .FirstOrDefaultAsync(m => m.AiId == id);
            if (artificialIntelligence == null)
            {
                return NotFound();
            }

            return View(artificialIntelligence);
        }

        // GET: ArtificialIntelligences/Create
        public IActionResult Create()
        {
            ViewData["PhotoId"] = new SelectList(_context.Photos, "PhotoId", "PhotoId");
            ViewData["UserId"] = new SelectList(_context.InterpolUsers, "UserId", "UserId");
            return View();
        }

        // POST: ArtificialIntelligences/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("AiId,AiName,AiRole,AiDescription,DateCreated,UserId,PhotoId")] ArtificialIntelligence artificialIntelligence)
        {
            if (ModelState.IsValid)
            {
                _context.Add(artificialIntelligence);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["PhotoId"] = new SelectList(_context.Photos, "PhotoId", "PhotoId", artificialIntelligence.PhotoId);
            ViewData["UserId"] = new SelectList(_context.InterpolUsers, "UserId", "UserId", artificialIntelligence.UserId);
            return View(artificialIntelligence);
        }

        // GET: ArtificialIntelligences/Edit/5
        public async Task<IActionResult> Edit(string id)
        {
            if (id == null || _context.ArtificialIntelligences == null)
            {
                return NotFound();
            }

            var artificialIntelligence = await _context.ArtificialIntelligences.FindAsync(id);
            if (artificialIntelligence == null)
            {
                return NotFound();
            }
            ViewData["PhotoId"] = new SelectList(_context.Photos, "PhotoId", "PhotoId", artificialIntelligence.PhotoId);
            ViewData["UserId"] = new SelectList(_context.InterpolUsers, "UserId", "UserId", artificialIntelligence.UserId);
            return View(artificialIntelligence);
        }

        // POST: ArtificialIntelligences/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, [Bind("AiId,AiName,AiRole,AiDescription,DateCreated,UserId,PhotoId")] ArtificialIntelligence artificialIntelligence)
        {
            if (id != artificialIntelligence.AiId)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(artificialIntelligence);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ArtificialIntelligenceExists(artificialIntelligence.AiId))
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
            ViewData["PhotoId"] = new SelectList(_context.Photos, "PhotoId", "PhotoId", artificialIntelligence.PhotoId);
            ViewData["UserId"] = new SelectList(_context.InterpolUsers, "UserId", "UserId", artificialIntelligence.UserId);
            return View(artificialIntelligence);
        }

        // GET: ArtificialIntelligences/Delete/5
        public async Task<IActionResult> Delete(string id)
        {
            if (id == null || _context.ArtificialIntelligences == null)
            {
                return NotFound();
            }

            var artificialIntelligence = await _context.ArtificialIntelligences
                .Include(a => a.Photo)
                .Include(a => a.User)
                .FirstOrDefaultAsync(m => m.AiId == id);
            if (artificialIntelligence == null)
            {
                return NotFound();
            }

            return View(artificialIntelligence);
        }

        // POST: ArtificialIntelligences/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            if (_context.ArtificialIntelligences == null)
            {
                return Problem("Entity set 'InterpolContext.ArtificialIntelligences'  is null.");
            }
            var artificialIntelligence = await _context.ArtificialIntelligences.FindAsync(id);
            if (artificialIntelligence != null)
            {
                _context.ArtificialIntelligences.Remove(artificialIntelligence);
            }
            
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool ArtificialIntelligenceExists(string id)
        {
          return (_context.ArtificialIntelligences?.Any(e => e.AiId == id)).GetValueOrDefault();
        }
    }
}
