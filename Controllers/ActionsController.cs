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
    public class ActionsController : Controller
    {
        private readonly InterpolContext _context;

        public ActionsController(InterpolContext context)
        {
            _context = context;
        }

        // GET: Actions
        public async Task<ActionResult<IEnumerable<ActionTable>>> Index()
        {
            if (_context.ActionTables == null)
            {
                return NotFound();
            }
            var interpolContext = _context.ActionTables.Include(a => a.Pin);
            return await interpolContext.ToListAsync();
        }

        // GET: Actions/Details/5
        public async Task<IActionResult> Details(string id)
        {
            if (id == null || _context.ActionTables == null)
            {
                return NotFound();
            }

            var actionTable = await _context.ActionTables
                .Include(a => a.Pin)
                .FirstOrDefaultAsync(m => m.ActionId == id);
            if (actionTable == null)
            {
                return NotFound();
            }

            return View(actionTable);
        }

        // GET: Actions/Create
        public IActionResult Create()
        {
            ViewData["PinId"] = new SelectList(_context.Pins, "PinId", "PinId");
            return View();
        }

        // POST: Actions/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("ActionId,ActionName,ActionDescription,DateCreated,PinId")] ActionTable actionTable)
        {
            if (ModelState.IsValid)
            {
                _context.Add(actionTable);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["PinId"] = new SelectList(_context.Pins, "PinId", "PinId", actionTable.PinId);
            return View(actionTable);
        }

        // GET: Actions/Edit/5
        public async Task<IActionResult> Edit(string id)
        {
            if (id == null || _context.ActionTables == null)
            {
                return NotFound();
            }

            var actionTable = await _context.ActionTables.FindAsync(id);
            if (actionTable == null)
            {
                return NotFound();
            }
            ViewData["PinId"] = new SelectList(_context.Pins, "PinId", "PinId", actionTable.PinId);
            return View(actionTable);
        }

        // POST: Actions/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, [Bind("ActionId,ActionName,ActionDescription,DateCreated,PinId")] ActionTable actionTable)
        {
            if (id != actionTable.ActionId)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(actionTable);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ActionTableExists(actionTable.ActionId))
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
            ViewData["PinId"] = new SelectList(_context.Pins, "PinId", "PinId", actionTable.PinId);
            return View(actionTable);
        }

        // GET: Actions/Delete/5
        public async Task<IActionResult> Delete(string id)
        {
            if (id == null || _context.ActionTables == null)
            {
                return NotFound();
            }

            var actionTable = await _context.ActionTables
                .Include(a => a.Pin)
                .FirstOrDefaultAsync(m => m.ActionId == id);
            if (actionTable == null)
            {
                return NotFound();
            }

            return View(actionTable);
        }

        // POST: Actions/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            if (_context.ActionTables == null)
            {
                return Problem("Entity set 'InterpolContext.ActionTables'  is null.");
            }
            var actionTable = await _context.ActionTables.FindAsync(id);
            if (actionTable != null)
            {
                _context.ActionTables.Remove(actionTable);
            }
            
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool ActionTableExists(string id)
        {
          return (_context.ActionTables?.Any(e => e.ActionId == id)).GetValueOrDefault();
        }
    }
}
