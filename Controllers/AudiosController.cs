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
    public class AudiosController : Controller
    {
        private readonly InterpolContext _context;

        public AudiosController(InterpolContext context)
        {
            _context = context;
        }

        // GET: Audios
        public async Task<IActionResult> Index()
        {
              return _context.Audios != null ? 
                          View(await _context.Audios.ToListAsync()) :
                          Problem("Entity set 'InterpolContext.Audios'  is null.");
        }

        // GET: Audios/Details/5
        public async Task<IActionResult> Details(string id)
        {
            if (id == null || _context.Audios == null)
            {
                return NotFound();
            }

            var audio = await _context.Audios
                .FirstOrDefaultAsync(m => m.AudioId == id);
            if (audio == null)
            {
                return NotFound();
            }

            return View(audio);
        }

        // GET: Audios/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: Audios/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("AudioId,FileName,AudioData")] Audio audio)
        {
            if (ModelState.IsValid)
            {
                _context.Add(audio);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(audio);
        }

        // GET: Audios/Edit/5
        public async Task<IActionResult> Edit(string id)
        {
            if (id == null || _context.Audios == null)
            {
                return NotFound();
            }

            var audio = await _context.Audios.FindAsync(id);
            if (audio == null)
            {
                return NotFound();
            }
            return View(audio);
        }

        // POST: Audios/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, [Bind("AudioId,FileName,AudioData")] Audio audio)
        {
            if (id != audio.AudioId)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(audio);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!AudioExists(audio.AudioId))
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
            return View(audio);
        }

        // GET: Audios/Delete/5
        public async Task<IActionResult> Delete(string id)
        {
            if (id == null || _context.Audios == null)
            {
                return NotFound();
            }

            var audio = await _context.Audios
                .FirstOrDefaultAsync(m => m.AudioId == id);
            if (audio == null)
            {
                return NotFound();
            }

            return View(audio);
        }

        // POST: Audios/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            if (_context.Audios == null)
            {
                return Problem("Entity set 'InterpolContext.Audios'  is null.");
            }
            var audio = await _context.Audios.FindAsync(id);
            if (audio != null)
            {
                _context.Audios.Remove(audio);
            }
            
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool AudioExists(string id)
        {
          return (_context.Audios?.Any(e => e.AudioId == id)).GetValueOrDefault();
        }
    }
}
