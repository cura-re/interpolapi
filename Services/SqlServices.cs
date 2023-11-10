using interpolapi.Data;
using AutoMapper;
using interpolapi.Authorization;

namespace interpolapi.Services;

public interface ISqlService
{
    // Function for saving an image
    Task<string> SaveImage(IFormFile imageFile);
    // Function for deleting an image
    void DeleteImage(string imageName);
    // Function for saving an audio file
    Task<string> SaveAudio(IFormFile imageFile);
    // Function for deleting an audio file
    void DeleteAudio(string imageName);
    // Function for saving a video
    Task<string> SaveVideo(IFormFile imageFile);
    // Function for deleting a video
    void DeleteVideo(string imageName);
}

public class SqlServices : ISqlService
{
    private InterpolContext _context;
    private IJwtUtils _jwtUtils;
    private readonly IMapper _mapper;
    private readonly IWebHostEnvironment _hostEnvironment;

    public SqlServices(
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