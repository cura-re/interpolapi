using AutoMapper;
using System.Data.SqlClient;
using interpolapi.Data;
using interpolapi.Authorization;
using interpolapi.Models;

namespace interpolapi.Services;

public interface ISqlService
{
    // Connect to sql
    void ConnectToSql(string queryString);
    // SqlDataReader Connect
    Task<string> SaveImage(IFormFile imageFile);
    void DeleteImage(string imageName);
    Task<string> SaveAudio(IFormFile imageFile);
    void DeleteAudio(string imageName);
    Task<string> SaveVideo(IFormFile imageFile);
    void DeleteVideo(string imageName);
}

public class SqlService : ISqlService
{
    private InterpolContext _context;
    private IJwtUtils _jwtUtils;
    private readonly IMapper _mapper;
    private readonly IWebHostEnvironment _hostEnvironment;

    public SqlService(
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
    
    public void ConnectToSql(string queryString)
    {
        var databaseConnection = System.Configuration.ConfigurationManager.ConnectionStrings["InterpolDb"].ConnectionString;
        using (SqlConnection connection = new SqlConnection(databaseConnection))
        {
            SqlCommand command = new SqlCommand(queryString, connection);
            command.Connection.Open();
            command.ExecuteNonQuery();
        } 
    }
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

    public void DeleteImage(string imageName)
    {
        var imagePath = Path.Combine(_hostEnvironment.ContentRootPath, "Images", imageName);
        if (System.IO.File.Exists(imagePath))
        {
            System.IO.File.Delete(imagePath);
        }
    }
    public async Task<string> SaveAudio(IFormFile imageFile)
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

    public void DeleteAudio(string imageName)
    {
        var imagePath = Path.Combine(_hostEnvironment.ContentRootPath, "Images", imageName);
        if (System.IO.File.Exists(imagePath))
        {
            System.IO.File.Delete(imagePath);
        }
    }
    public async Task<string> SaveVideo(IFormFile imageFile)
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

    public void DeleteVideo(string imageName)
    {
        var imagePath = Path.Combine(_hostEnvironment.ContentRootPath, "Images", imageName);
        if (System.IO.File.Exists(imagePath))
        {
            System.IO.File.Delete(imagePath);
        }
    }
}