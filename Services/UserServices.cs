using AutoMapper;
using interpolapi.Authorization;
using interpolapi.Helpers;
using interpolapi.Models;
using interpolapi.Models.Users;
using interpolapi.Data;
using Microsoft.AspNetCore.Mvc;
using System.Text;

namespace interpolapi.Services
{
    public interface IUserService
    {
        AuthenticateResponse Authenticate(AuthenticateRequest model);
        IEnumerable<InterpolUser> GetAll();
        InterpolUser GetById(string id);
        void Register(RegisterRequest model);
        void Update(string id, UpdateRequest model);
        void Delete(string id);
    }

    public class UserService : IUserService
    {
        private InterpolContext _context;
        private IJwtUtils _jwtUtils;
        private readonly IMapper _mapper;
        private readonly IWebHostEnvironment _hostEnvironment;

        public UserService(
            InterpolContext context,
            IJwtUtils jwtUtils,
            IMapper mapper,
            IWebHostEnvironment hostEnvironment)
        {
            _context = context;
            _jwtUtils = jwtUtils;
            _mapper = mapper;
            _hostEnvironment = hostEnvironment;
        }

        public AuthenticateResponse Authenticate(AuthenticateRequest model)
        {
            var user = _context.InterpolUsers.SingleOrDefault(x => x.UserName == model.Username);

            // validate
            if (user == null)
                throw new AppException("User does not exist");

            if (!BCrypt.Net.BCrypt.Verify(model.Password, user.UserPassword.ToString()))
                throw new AppException("Password is incorrect");

            // authentication successful
            var response = _mapper.Map<AuthenticateResponse>(user);
            response.Token = _jwtUtils.GenerateToken(user);
            return response;
        }

        public IEnumerable<InterpolUser> GetAll()
        {
            return _context.InterpolUsers;
        }

        public InterpolUser GetById(string id)
        {
            return GetUser(id);
        }

        public void Register(RegisterRequest model)
        {
            // validate
            if (_context.InterpolUsers.Any(x => x.UserName == model.Username))
                throw new AppException("Username '" + model.Username + "' is already taken");

            // map model to new user object
            var user = _mapper.Map<InterpolUser>(model);

            // hash password
            user.UserPassword = Encoding.ASCII.GetBytes( BCrypt.Net.BCrypt.HashPassword(model.Password));

            // save user
            _context.InterpolUsers.Add(user);
            _context.SaveChanges();
        }

        public void Update(string id, UpdateRequest model)
        {
            var user = GetUser(id);

            // validate
            if (model.Username != user.UserName && _context.InterpolUsers.Any(x => x.UserName == model.Username))
                throw new AppException("Username '" + model.Username + "' is already taken");

            // hash password if it was entered
            if (!string.IsNullOrEmpty(model.Password))
                user.UserPassword = Encoding.ASCII.GetBytes( BCrypt.Net.BCrypt.HashPassword(model.Password));

            // copy model to user and save
            _mapper.Map(model, user);
            _context.InterpolUsers.Update(user);
            _context.SaveChanges();
        }

        public void Delete(string id)
        {
            var user = GetUser(id);
            _context.InterpolUsers.Remove(user);
            _context.SaveChanges();
        }

        // helper methods

        private InterpolUser GetUser(string id)
        {
            var user = _context.InterpolUsers.Find(id);
            //if (user == null) throw new KeyNotFoundException("User not found");
            return user;
        }

        [NonAction]
        public async Task<string> SaveImage(IFormFile imageFile)
        {
            string imageName = new String(Path.GetFileNameWithoutExtension(imageFile.FileName).Take(10).ToArray()).Replace(' ', '-');
            imageName = imageName + DateTime.Now.ToString("yymmssfff") + Path.GetExtension(imageFile.FileName);
            var imagePath = Path.Combine(_hostEnvironment.ContentRootPath, "Images", imageName);
            using (var fileStream = new FileStream(imagePath, FileMode.Create))
            {
                await imageFile.CopyToAsync(fileStream);
            }
            return imageName;
        }

        [NonAction]
        public void DeleteImage(string imageName)
        {
            var imagePath = Path.Combine(_hostEnvironment.ContentRootPath, "Images", imageName);
            if (System.IO.File.Exists(imagePath))
                System.IO.File.Delete(imagePath);
        }
    }
}