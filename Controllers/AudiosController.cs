using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using interpolapi.Data;
using interpolapi.Models;
using System.Data.SqlClient;

namespace interpolapi.Controllers
{
    public class AudiosController : Controller
    {
        private readonly InterpolContext _context;
        private readonly IConfiguration _configuration;
        private string? databaseConnection;

        public AudiosController(InterpolContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
            databaseConnection = _configuration.GetConnectionString("InterpolDb");
        }

        // GET: Audios
        public async Task<ActionResult<IEnumerable<Audio>>> Index()
        {
            if (_context.Audios == null)
            {
                return NotFound();
            }
            IList<Audio> audioList = new List<Audio>(); 
            await using (SqlConnection connection = new SqlConnection(databaseConnection))
            {
                SqlCommand command = new SqlCommand("interpol.getAudio", connection);
                command.Connection.Open();
                SqlDataReader reader = command.ExecuteReader();
                while(reader.Read())
                {
                    var audio = new Audio()
                    {
                        AudioId = reader["audio_id"].ToString(),
                        FileName = reader["file_name"].ToString(),
                    };
                    if (!Convert.IsDBNull(reader["audio_data"])) 
                    {
                        audio.AudioData = (byte[])reader["audio_data"];
                    }
                    audioList.Add(audio);
                }
            } 
            return audioList.ToList();
        }

        // GET: Audios/Details/5
        public async Task<ActionResult<Audio>> Details(string id)
        {
            if (id == null || _context.Audios == null)
            {
                return NotFound();
            }

            await using (SqlConnection connection = new SqlConnection(databaseConnection))
            {
                SqlCommand command = new SqlCommand("interpol.getSingleAudio", connection);
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@AudioId", id);
                command.Connection.Open();
                SqlDataReader reader = command.ExecuteReader();
                var audio = new Audio();
                while(reader.Read())
                {
                    audio.AudioId = reader["audio_id"].ToString();
                    audio.FileName = reader["file_name"].ToString();
                    if (!Convert.IsDBNull(reader["audio_data"])) 
                    {
                        audio.AudioData = (byte[])reader["audio_data"];
                    }
                }
                return audio;
            }
        }

        // POST: Audios/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<Audio> Create([FromForm] Audio audio)
        {
            await using (SqlConnection connection = new SqlConnection(databaseConnection))
            {
                SqlCommand command = new SqlCommand("interpol.importAudio", connection);
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@FileName", audio.FileName);
                command.Parameters.AddWithValue("@AudioData", audio.AudioData);
                command.Connection.Open();
                command.ExecuteNonQuery();
                return audio;
            } 
        }

        // POST: Audios/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPut]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult<Audio>> Edit(string id, [FromForm] Audio audio)
        {
            if (id != audio.AudioId)
            {
                return NotFound();
            }

            await using (SqlConnection connection = new SqlConnection(databaseConnection))
            {
                SqlCommand command = new SqlCommand("interpol.updateAudio", connection);
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@FileName", audio.FileName);
                command.Parameters.AddWithValue("@AudioData", audio.AudioData);
                command.Connection.Open();
                command.ExecuteNonQuery();
                return audio;
            } 
        }

        // POST: Audios/Delete/5
        [HttpDelete, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            string userId = HttpContext.Request.Cookies["user"];
            await using (SqlConnection connection = new SqlConnection(databaseConnection))
            {
                SqlCommand command = new SqlCommand("interpol.deleteAudio", connection);
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@AudioId", id);
                command.Parameters.AddWithValue("@pUserId", userId);
                command.Connection.Open();
                command.ExecuteNonQuery();
                return Problem("Entity set 'InterpolContext.InterpolUsers'  is null.");
            } 
        }

        private bool AudioExists(string id)
        {
          return (_context.Audios?.Any(e => e.AudioId == id)).GetValueOrDefault();
        }
    }
}
