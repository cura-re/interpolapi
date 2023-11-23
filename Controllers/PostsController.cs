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
    public class PostsController : Controller
    {
        private readonly InterpolContext _context;
        private readonly IConfiguration _configuration;
        private string? databaseConnection;

        public PostsController(InterpolContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
            databaseConnection = _configuration.GetConnectionString("InterpolDb");
        }

        public async Task<ActionResult<IEnumerable<Post>>> Index()
        {
            if (_context.Posts == null)
            {
                return NotFound();
            }
            IList<Post> postsList = new List<Post>(); 
            await using (SqlConnection connection = new SqlConnection(databaseConnection))
            {
                SqlCommand command = new SqlCommand("interpol.getPosts", connection);
                command.Connection.Open();
                SqlDataReader reader = command.ExecuteReader();
                while(reader.Read())
                {
                    var post = new Post()
                    {
                        PostId = reader["post_id"].ToString(),
                        PostContent = reader["post_content"].ToString(),
                        DateCreated = (DateTime)reader["date_created"],
                        PhotoId = reader["photo_id"].ToString(),
                        ImageLink = reader["image_link"].ToString(),
                        User = new InterpolUser() { UserName = reader["user_name"].ToString(), FirstName = reader["first_name"].ToString(), UserId = reader["user_id"].ToString()}
                    };
                    if (!Convert.IsDBNull(reader["image_data"])) 
                    {
                        post.ImageData = (byte[])reader["image_data"];
                    }
                    postsList.Add(post);
                }
            } 
            return postsList.ToList();
        }

        public async Task<ActionResult<IEnumerable<Post>>> Search(string? id)
        {
            if (id  == null || _context.Posts == null)
            {
                return NotFound();
            }

            IList<Post> postsList = new List<Post>();
            await using (SqlConnection connection = new SqlConnection(databaseConnection))
            {
                SqlCommand command = new SqlCommand("interpol.getSinglePost", connection);
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@pPostContent", id);
                command.Connection.Open();
                SqlDataReader reader = command.ExecuteReader();
                while(reader.Read())
                {
                    Post post = new Post()
                    {
                        PostId = reader["post_id"].ToString(),
                        PostContent = reader["post_content"].ToString(),
                        DateCreated = (DateTime)reader["date_created"],
                        PhotoId = reader["photo_id"].ToString(),
                        ImageLink = reader["image_link"].ToString(),
                        User = new InterpolUser() { 
                            UserName = reader["user_name"].ToString(), FirstName = reader["first_name"].ToString(), UserId = reader["user_id"].ToString()
                        }
                    };
                    if (!Convert.IsDBNull(reader["image_data"])) 
                    {
                        post.ImageData = (byte[])reader["image_data"];
                    }
                    postsList.Add(post);
                }
                return postsList.ToList();
            } 
        }

        public async Task<ActionResult<Post>> Details(string? id)
        {
            if (id  == null || _context.Posts == null)
            {
                return NotFound();
            }

            await using (SqlConnection connection = new SqlConnection(databaseConnection))
            {
                SqlCommand command = new SqlCommand("interpol.getSinglePost", connection);
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@pPostId", id);
                command.Connection.Open();
                SqlDataReader reader = command.ExecuteReader();
                Post post = new Post();
                while(reader.Read())
                {
                    {
                        post.PostId = reader["post_id"].ToString();
                        post.PostContent = reader["post_content"].ToString();
                        post.DateCreated = (DateTime)reader["date_created"];
                        post.PhotoId = reader["photo_id"].ToString();
                        post.ImageLink = reader["image_link"].ToString();
                        post.User = new InterpolUser() { 
                            UserName = reader["user_name"].ToString(), FirstName = reader["first_name"].ToString(), UserId = reader["user_id"].ToString()
                        };
                    };
                    if (!Convert.IsDBNull(reader["image_data"])) 
                    {
                        post.ImageData = (byte[])reader["image_data"];
                    }
                }
                return post;
            } 
        }
        
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<Post> Create([FromForm] Post post)
        {
            string userId = HttpContext.Request.Cookies["user"];
            await using (SqlConnection connection = new SqlConnection(databaseConnection))
            {
                SqlCommand command = new SqlCommand("interpol.addPost", connection);
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@pUserId", userId);
                command.Parameters.AddWithValue("@pPostContent", post.PostContent);
                command.Parameters.AddWithValue("@ImageLink", post.ImageLink);
                command.Parameters.AddWithValue("@ImageData", post.ImageData);
                command.Connection.Open();
                command.ExecuteNonQuery();
                return post;
            } 
        }

        [HttpPut]
        [ValidateAntiForgeryToken]
        public async Task<Post> Update([FromForm] Post post)
        {
            string userId = HttpContext.Request.Cookies["user"];
            await using (SqlConnection connection = new SqlConnection(databaseConnection))
            {
                SqlCommand command = new SqlCommand("interpol.updatePost", connection);
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@pPostId", post.PostId);
                command.Parameters.AddWithValue("@pPostContent", post.PostContent);
                command.Parameters.AddWithValue("@pUseId", userId);
                command.Parameters.AddWithValue("@ImageLink", post.ImageLink);
                command.Parameters.AddWithValue("@ImageData", post.ImageData);
                command.Connection.Open();
                command.ExecuteNonQuery();
                return post;
            } 
        }

        [HttpDelete]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(string id)
        {
            if (_context.Posts == null)
            {
                return Problem("Entity set 'InterpolContext.InterpolUsers'  is null.");
            }

            string userId = HttpContext.Request.Cookies["user"];
            await using (SqlConnection connection = new SqlConnection(databaseConnection))
            {
                SqlCommand command = new SqlCommand("interpol.deletePost", connection);
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@pPostId", id);
                command.Parameters.AddWithValue("@pUserId", userId);
                command.Connection.Open();
                command.ExecuteNonQuery();
                return Problem("Entity set 'InterpolContext.InterpolUsers'  is null.");
            } 
        }

        private bool PostExists(string id)
        {
            return (_context.Posts?.Any(e => e.PostId == id)).GetValueOrDefault();
        }
    }
}
