﻿using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using interpolapi.Authorization;
using interpolapi.Helpers;
using interpolapi.Models.Users;
using interpolapi.Services;
using interpolapi.Models;
using interpolapi.Data;
using Microsoft.EntityFrameworkCore;

namespace interpolapi.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class ServicesController : ControllerBase
    {
        private IUserService _userService;
        private IMapper _mapper;
        private readonly AppSettings _appSettings;
        private readonly IWebHostEnvironment _hostEnvironment;

        public ServicesController(
            IUserService userService,
            IMapper mapper,
            IOptions<AppSettings> appSettings,
            IWebHostEnvironment hostEnvironment
            )
        {
            _userService = userService;
            _mapper = mapper;
            _appSettings = appSettings.Value;
            _hostEnvironment = hostEnvironment;
        }

        [AllowAnonymous]
        [HttpPost("authenticate")]
        public IActionResult Authenticate(AuthenticateRequest model)
        {
            var response = _userService.Authenticate(model);

            var cookieOptions = new CookieOptions
            {
                // Set the secure flag, which Chrome's changes will require for SameSite none.
                // Note this will also require you to be running on HTTPS.
                Secure = true,

                // Set the cookie to HTTP only which is good practice unless you really do need
                // to access it client side in scripts.
                HttpOnly = true,

                // Add the SameSite attribute, this will emit the attribute with a value of none.
                SameSite = SameSiteMode.None

                // The client should follow its default cookie policy.
                // SameSite = SameSiteMode.Unspecified
            };

            cookieOptions.Expires = DateTime.Now.AddDays(7);

            cookieOptions.Path = "/";

            Response.Cookies.Append("token", response.Token, cookieOptions);

            Response.Cookies.Append("user", response.UserId.ToString(), cookieOptions);

            return Ok(response);
        }

        [AllowAnonymous]
        [HttpPost("register")]
        public async Task<ActionResult<InterpolUser>> Register([FromForm] RegisterRequest model)
        {
            if (model.ImageFile != null)
            {
                model.ImageLink = await SaveImage(model.ImageFile);
            }

            _userService.Register(model);

            AuthenticateRequest authenticateModel = new AuthenticateRequest();

            authenticateModel.Username = model.Username;
            authenticateModel.Password = model.Password;

            Authenticate(authenticateModel);
            return Ok(new { message = "Registration successful" });
        }

        [AllowAnonymous]
        [HttpPost("logout")]
        public IActionResult Logout()
        {
            var token = Request.Cookies["token"];

            var user = Request.Cookies["user"];

            if (token != null && user != null)
            {
                var cookieOptions = new CookieOptions
                {
                    // Set the secure flag, which Chrome's changes will require for SameSite none.
                    // Note this will also require you to be running on HTTPS.
                    Secure = true,

                    // Set the cookie to HTTP only which is good practice unless you really do need
                    // to access it client side in scripts.
                    HttpOnly = true,

                    // Add the SameSite attribute, this will emit the attribute with a value of none.
                    SameSite = SameSiteMode.None

                    // The client should follow its default cookie policy.
                    // SameSite = SameSiteMode.Unspecified
                };

                cookieOptions.Expires = DateTime.Now.AddDays(-1);

                cookieOptions.Path = "/";

                Response.Cookies.Append("token", token, cookieOptions);

                Response.Cookies.Append("user", user, cookieOptions);
            }

            return Ok(new { message = "Logout successful" });
        }

        [HttpGet]
        public IActionResult GetUsers()
        {
           var users = _userService.GetAll();
           return Ok(users);
        }

        [AllowAnonymous]
        [HttpGet("data")]
        public IActionResult GetUserInformation()
        {
            var userId = HttpContext.Request.Cookies["user"];

            var user = _userService.GetById(userId);

            if (user != null) 

            user.ImageLink = String.Format("{0}://{1}{2}/images/{3}", Request.Scheme, Request.Host, Request.PathBase, user.ImageLink);

            return Ok(user);
        }

        [HttpPut("{id}")]
        public IActionResult Update(string id, UpdateRequest model)
        {
            _userService.Update(id, model);
            return Ok(new { message = "User updated successfully" });
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(string id)
        {
            _userService.Delete(id);
            return Ok(new { message = "User deleted successfully" });
        }

        [NonAction]
        public async Task<string> SaveImage(IFormFile imageFile)
        {
            string imageName = new String(Path.GetFileNameWithoutExtension(imageFile.FileName).Take(10).ToArray()).Replace(' ', '-');
            imageName = imageName + DateTime.Now.ToString("yymmssfff") + Path.GetExtension(imageFile.FileName);
            var imagePath = Path.Combine(_hostEnvironment.WebRootPath, "images", imageName);
            using (var fileStream = new FileStream(imagePath, FileMode.Create))
            {
                await imageFile.CopyToAsync(fileStream);
            }
            return imageName;
        }

        [NonAction]
        public void DeleteImage(string imageName)
        {
            var imagePath = Path.Combine(_hostEnvironment.WebRootPath, "images", imageName);
            if (System.IO.File.Exists(imagePath))
                System.IO.File.Delete(imagePath);
        }
    }
}