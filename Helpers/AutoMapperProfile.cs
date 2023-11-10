using AutoMapper;
using interpolapi.Models;
using interpolapi.Models.Users;

namespace interpolapi.Helpers
{
    public class AutoMapperProfile : Profile
    {
        public AutoMapperProfile()
        {
            // User -> AuthenticateResponse
            CreateMap<InterpolUser, AuthenticateResponse>();

            // RegisterRequest -> User
            CreateMap<RegisterRequest, InterpolUser>();

            // UpdateRequest -> User
            CreateMap<UpdateRequest, InterpolUser>()
                .ForAllMembers(x => x.Condition(
                    (src, dest, prop) =>
                    {
                        // ignore null & empty string properties
                        if (prop == null) return false;
                        if (prop.GetType() == typeof(string) && string.IsNullOrEmpty((string)prop)) return false;

                        return true;
                    }
                ));
        }
    }
}