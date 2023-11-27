using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Configuration;
using System.Text;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using Microsoft.Extensions.Configuration;
using System.Data.SqlClient;  
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using interpolapi.Data;
using interpolapi.Models;

namespace interpolapi.Controllers
{
    public class PhotosController : Controller
    {
        private readonly InterpolContext _context;
        private readonly IConfiguration _configuration;
        private string? databaseConnection;

        public PhotosController(InterpolContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
            databaseConnection = _configuration.GetConnectionString("InterpolDb");
        }

        // GET: Photos
        public async Task<ActionResult<IEnumerable<Photo>>> Index()
        {
            if (_context.Photos == null)
            {
                return NotFound();
            }
            IList<Photo> photosList = new List<Photo>(); 
            await using (SqlConnection connection = new SqlConnection(databaseConnection))
            {
                SqlCommand command = new SqlCommand("interpol.getPhotos", connection);
                command.Connection.Open();
                SqlDataReader reader = command.ExecuteReader();
                while(reader.Read())
                {
                    var photo = new Photo()
                    {
                        PhotoId = reader["photo_id"].ToString(),
                        ImageLink = reader["image_link"].ToString(),
                        ImageSource = reader["image_source"].ToString(),
                        ImageData = (byte[])reader["image_data"]
                    };
                    photosList.Add(photo);
                }
            } 
            return photosList.ToList();
        }

        // GET: Photos/Details/5
        public async Task<ActionResult<Photo>> Details(string id)
        {
            if (id == null || _context.Photos == null)
            {
                return NotFound();
            }

            await using (SqlConnection connection = new SqlConnection(databaseConnection))
            {
                SqlCommand command = new SqlCommand("interpol.getSinglePhoto", connection);
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@PhotoId", id);
                command.Connection.Open();
                SqlDataReader reader = command.ExecuteReader();
                var photo = new Photo();
                while(reader.Read())
                {
                    photo.PhotoId = reader["photo_id"].ToString();
                    photo.ImageLink = reader["image_link"].ToString();
                    photo.ImageSource = reader["image_source"].ToString();
                    photo.ImageData = (byte[])reader["image_data"];
                }
                return photo;
            } 
        }

        // POST: Photos/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<Photo> Create([FromForm] Photo photo)
        {
            await using (SqlConnection connection = new SqlConnection(databaseConnection))
            {
                SqlCommand command = new SqlCommand("interpol.getSinglePhoto", connection);
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@ImageLink", photo.ImageLink);
                command.Parameters.AddWithValue("@ImageSource", photo.ImageSource);
                command.Parameters.AddWithValue("@ImageData", photo.ImageData);
                command.Connection.Open();
                command.ExecuteNonQuery();
                return photo;
            } 
        }

        // POST: Photos/Delete/5
        [HttpDelete, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            if (_context.Photos == null)
            {
                return Problem("Entity set 'InterpolContext.Photos'  is null.");
            }
            await using (SqlConnection connection = new SqlConnection(databaseConnection))
            {
                SqlCommand command = new SqlCommand("interpol.deleteImage", connection);
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@ImageLink", id);
                command.Connection.Open();
                command.ExecuteNonQuery();
                return Problem("Entity set 'InterpolContext.Photos'  is null.");
            } 
        }

        private bool PhotoExists(string id)
        {
          return (_context.Photos?.Any(e => e.PhotoId == id)).GetValueOrDefault();
        }
    }
}