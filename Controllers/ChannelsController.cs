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
    public class ChannelsController : Controller
    {
        private readonly InterpolContext _context;

        public ChannelsController(InterpolContext context)
        {
            _context = context;
        }

        // GET: Channels
        public async Task<IActionResult> Index()
        {
            var interpolContext = _context.Channels.Include(c => c.Community);
            return View(await interpolContext.ToListAsync());
        }

        // GET: Channels/Details/5
        public async Task<IActionResult> Details(string id)
        {
            if (id == null || _context.Channels == null)
            {
                return NotFound();
            }

            var channel = await _context.Channels
                .Include(c => c.Community)
                .FirstOrDefaultAsync(m => m.ChannelId == id);
            if (channel == null)
            {
                return NotFound();
            }

            return View(channel);
        }

        // GET: Channels/Create
        public IActionResult Create()
        {
            ViewData["CommunityId"] = new SelectList(_context.Communities, "CommunityId", "CommunityId");
            return View();
        }

        // POST: Channels/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("ChannelId,ChannelName,DateCreated,ChannelDescription,CommunityId")] Channel channel)
        {
            if (ModelState.IsValid)
            {
                _context.Add(channel);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["CommunityId"] = new SelectList(_context.Communities, "CommunityId", "CommunityId", channel.CommunityId);
            return View(channel);
        }

        // GET: Channels/Edit/5
        public async Task<IActionResult> Edit(string id)
        {
            if (id == null || _context.Channels == null)
            {
                return NotFound();
            }

            var channel = await _context.Channels.FindAsync(id);
            if (channel == null)
            {
                return NotFound();
            }
            ViewData["CommunityId"] = new SelectList(_context.Communities, "CommunityId", "CommunityId", channel.CommunityId);
            return View(channel);
        }

        // POST: Channels/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, [Bind("ChannelId,ChannelName,DateCreated,ChannelDescription,CommunityId")] Channel channel)
        {
            if (id != channel.ChannelId)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(channel);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ChannelExists(channel.ChannelId))
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
            ViewData["CommunityId"] = new SelectList(_context.Communities, "CommunityId", "CommunityId", channel.CommunityId);
            return View(channel);
        }

        // GET: Channels/Delete/5
        public async Task<IActionResult> Delete(string id)
        {
            if (id == null || _context.Channels == null)
            {
                return NotFound();
            }

            var channel = await _context.Channels
                .Include(c => c.Community)
                .FirstOrDefaultAsync(m => m.ChannelId == id);
            if (channel == null)
            {
                return NotFound();
            }

            return View(channel);
        }

        // POST: Channels/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            if (_context.Channels == null)
            {
                return Problem("Entity set 'InterpolContext.Channels'  is null.");
            }
            var channel = await _context.Channels.FindAsync(id);
            if (channel != null)
            {
                _context.Channels.Remove(channel);
            }
            
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool ChannelExists(string id)
        {
          return (_context.Channels?.Any(e => e.ChannelId == id)).GetValueOrDefault();
        }
    }
}
