using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using tvz2api_cqrs.Hubs;
using tvz2api_cqrs.Implementation.CommandHandlers;
using tvz2api_cqrs.Implementation.Commands;
using tvz2api_cqrs.Implementation.Queries;
using tvz2api_cqrs.Implementation.QueryHandlers;
using tvz2api_cqrs.Infrastructure.CommandHandlers;
using tvz2api_cqrs.Infrastructure.Commands;
using tvz2api_cqrs.Infrastructure.Messaging;
using tvz2api_cqrs.Infrastructure.QueryHandlers;
using tvz2api_cqrs.Models;
using tvz2api_cqrs.Models.DTO;
using tvz2api_cqrs.QueryModels;
using Microsoft.AspNetCore.Identity;
using tvz2api_cqrs.Custom;
using Microsoft.EntityFrameworkCore;

namespace tvz2api_cqrs
{
  public class Startup
  {
    public Startup(IConfiguration configuration)
    {
      _configuration = configuration;
    }

    public IConfiguration _configuration { get; }

    public void ConfigureServices(IServiceCollection services)
    {
      ConfigureAdditionalServices(services);
      services.AddSignalR();
      services.AddDbContext<lmsContext>(options =>
        options.UseSqlServer(_configuration.GetConnectionString("tvz2")));
      services.AddControllers().AddNewtonsoftJson(options =>
        options.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore
      );
      services.AddHttpsRedirection(options =>
      {
        options.RedirectStatusCode = StatusCodes.Status307TemporaryRedirect;
        options.HttpsPort = 5001;
      });
      services.AddAuthorization(options =>
      {
        var defaultAuthorizationPolicyBuilder = new AuthorizationPolicyBuilder(JwtBearerDefaults.AuthenticationScheme);
        defaultAuthorizationPolicyBuilder = defaultAuthorizationPolicyBuilder.RequireAuthenticatedUser();
        options.DefaultPolicy = defaultAuthorizationPolicyBuilder.Build();
      });
      services.AddCors(options =>
      {
        options.AddDefaultPolicy(
          builder =>
          {
            builder
              .WithOrigins(new string[] { "http://localhost:8080", "https://localhost:8080", "null" })
              .AllowAnyHeader()
              .AllowAnyMethod()
              .AllowCredentials()
              .SetIsOriginAllowedToAllowWildcardSubdomains();
          });
      });
      services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
      .AddJwtBearer(options =>
      {
        options.TokenValidationParameters = new TokenValidationParameters
        {
          ValidateIssuerSigningKey = true,
          IssuerSigningKey = new SymmetricSecurityKey(Encoding.ASCII.GetBytes(_configuration.GetSection("AppSettings:Token").Value)),
          ValidateIssuer = false,
          ValidateAudience = false
        };
      });
      services.AddSwaggerGen(c =>
      {
        c.SwaggerDoc("v1", new OpenApiInfo { Title = "tvz2cqrs", Version = "v1" });
        c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
        {
          Description = "Enter Bearer [space] and then your token in the text input below.",
          Name = "Authorization",
          In = ParameterLocation.Header,
          Type = SecuritySchemeType.ApiKey,
          Scheme = "Bearer"
        });
        c.AddSecurityRequirement(new OpenApiSecurityRequirement()
        {
          {
            new OpenApiSecurityScheme
            {
              Reference = new OpenApiReference
              {
                Type = ReferenceType.SecurityScheme,
                Id = "Bearer"
              },
              Scheme = "oauth2",
              Name = "Bearer",
              In = ParameterLocation.Header
            },
            new List<string>()
          }
        });
      });
      services.AddHttpContextAccessor();
      services.AddTransient<IUserResolver, UserResolver>();
    }

    public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
    {
      if (env.IsDevelopment())
      {
        app.UseDeveloperExceptionPage();
      }
      app.UseCors();
      app.UseHttpsRedirection();
      app.UseWebSockets();
      app.UseSwagger();
      app.UseSwaggerUI(c =>
      {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "tvz2cqrs");
      });
      app.UseRouting();
      app.UseAuthentication();
      app.UseAuthorization();
      app.UseEndpoints(endpoints =>
      {
        endpoints.MapControllers();
        endpoints.MapHub<NotificationHub>("/notification-hub");
        endpoints.MapHub<ChatHub>("/chat-hub");
      });
    }

    public void ConfigureAdditionalServices(IServiceCollection services)
    {
      services.AddScoped<ICommandBus, CommandBus>();
      services.AddScoped<IEventBus, EventBus>();
      services.AddScoped<IQueryBus, QueryBus>();

      // Course queries
      services.AddScoped<IQueryHandlerAsync<CourseQuery, List<CourseQueryModel>>, CourseQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<CourseTotalQuery, int>, CourseQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<UserCourseQuery, List<UserCourseDetailsDTO>>, CourseQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<UserCourseTotalQuery, int>, CourseQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<CourseDetailsQuery, CourseDetailsQueryModel>, CourseQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<CourseSidebarQuery, List<SidebarContentDTO>>, CourseQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<CourseNotificationsQuery, List<NotificationQueryModel>>, CourseQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<CourseDiscussionsQuery, List<DiscussionDTO>>, CourseQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<CourseLandingPageQuery, string>, CourseQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<CourseDiscussionRepliesQuery, List<DiscussionReplyDTO>>, CourseQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<CourseUserGradesQuery, CourseUserGradesQueryModel>, CourseQueryHandler>();

      // Course commands
      services.AddScoped<ICommandHandlerAsync<CourseCreateNewSidebarCommand>, CourseCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<CourseDeleteSidebarCommand>, CourseCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<CourseCreateDiscussionCommand>, CourseCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<CourseDiscussionReplyCommand>, CourseCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<CourseDeleteDiscussionCommand>, CourseCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<CourseUpdateLandingPageCommand>, CourseCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<CourseUpdatePasswordCommand>, CourseCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<CourseDeleteCommand>, CourseCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<CourseMuteParticipantCommand>, CourseCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<CourseKickParticipantCommand>, CourseCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<CourseCreateCommand, int>, CourseCommandHandler>();

      // File commands
      services.AddScoped<ICommandHandlerAsync<FileUploadCommand, List<int>>, FileCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<FileUploadSidebarCommand, List<int>>, FileCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<FileDeleteCommand>, FileCommandHandler>();

      // File queries
      services.AddScoped<IQueryHandlerAsync<FileQuery, List<FileQueryModel>>, FileQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<FileDownloadMultipleQuery, FileDTO>, FileQueryHandler>();

      // Authentication commands
      services.AddScoped<ICommandHandlerAsync<AuthenticationRegisterCommand>, AuthenticationCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<AuthenticationLoginCommand, LoginUserDTO>, AuthenticationCommandHandler>();

      // Authentication queries
      services.AddScoped<IQueryHandlerAsync<AuthenticationCheckUsernameQuery, bool>, AuthenticationQueryHandler>();

      // User commands
      services.AddScoped<ICommandHandlerAsync<UserSubscribeCommand>, UserCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<UserUnsubscribeCommand>, UserCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<UserUpdateSettingsCommand>, UserCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<UserUploadPictureCommand, UserProfilePictureDTO>, UserCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<UserUpdatePersonalInformationCommand>, UserCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<UserUpdateBlacklistCommand>, UserCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<UserUpdateGeneralCommand>, UserCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<UserUpdatePrivilegesCommand>, UserCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<UserUpdateSpecificCommand>, UserCommandHandler>();

      // Notification queries
      services.AddScoped<IQueryHandlerAsync<NotificationQuery, List<NotificationQueryModel>>, NotificationQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<NotificationUserQuery, List<NotificationQueryModel>>, NotificationQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<NotificationUserTotalQuery, int>, NotificationQueryHandler>();

      // Notification commands
      services.AddScoped<ICommandHandlerAsync<NotificationCreateCommand>, NotificationCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<NotificationSeenCommand>, NotificationCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<NotificationDeleteCommand>, NotificationCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<NotificationArchiveCommand>, NotificationCommandHandler>();

      // User queries
      services.AddScoped<IQueryHandlerAsync<UserQuery, List<UserQueryModel>>, UserQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<UserTotalQuery, int>, UserQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<UserChatQuery, List<UserChatQueryModel>>, UserQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<UserSettingsQuery, UserSettingsQueryModel>, UserQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<UserDetailsQuery, UserDetailsDTO>, UserQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<UserSubscriptionQuery, List<int>>, UserQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<UserBlacklistQuery, List<BlacklistDTO>>, UserQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<UserGetAllQuery, List<UserQueryModel>>, UserQueryHandler>();

      // Chat queries
      services.AddScoped<IQueryHandlerAsync<ChatDetailsQuery, ChatQueryModel>, ChatQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<ChatAvailableUsersQuery, List<UserQueryModel>>, ChatQueryHandler>();

      // Chat commands
      services.AddScoped<ICommandHandlerAsync<SendMessageCommand, MessageDTO>, ChatCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<CreateNewChatCommand, NewChatDTO>, ChatCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<DeleteMessageCommand>, ChatCommandHandler>();

      // Exam queries
      services.AddScoped<IQueryHandlerAsync<ExamInProgressDetailsQuery, ExamAttemptDetailsQueryModel>, ExamQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<ExamInProgressQuery, List<ExamAttemptQueryModel>>, ExamQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<ExamUnfinishedQuery, List<UnfinishedExamDTO>>, ExamQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<ExamFinishedQuery, List<FinishedExamDTO>>, ExamQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<ExamUnfinishedDetailsQuery, ExamUnfinishedDetailsQueryModel>, ExamQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<ExamPreviewQuery, ExamPreviewQueryModel>, ExamQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<ExamAvailableQuery, List<FinishedExamDTO>>, ExamQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<ExamInProgressCourseQuery, List<ExamInProgressDTO>>, ExamQueryHandler>();

      // Exam commands
      services.AddScoped<ICommandHandlerAsync<ExamUpdateAttemptCommand>, ExamCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<ExamStartAttemptCommand, int>, ExamCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<ExamUpdateCommand>, ExamCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<ExamPreCreateCommand, int>, ExamCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<ExamFinalizeCommand>, ExamCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<ExamEnableSolvingCommand>, ExamCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<ExamFinishAttemptCommand>, ExamCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<ExamDeleteUnfinishedCommand>, ExamCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<ExamDeleteFinishedCommand>, ExamCommandHandler>();

      // CourseTask commands
      services.AddScoped<ICommandHandlerAsync<CourseTaskCreateCommand>, CourseTaskCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<CourseTaskUpdateCommand>, CourseTaskCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<CourseTaskDeleteCommand>, CourseTaskCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<CourseTaskSubmitAttemptCommand>, CourseTaskCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<CourseTaskEditAttemptCommand>, CourseTaskCommandHandler>();
      services.AddScoped<ICommandHandlerAsync<CourseTaskGradeAttemptCommand>, CourseTaskCommandHandler>();

      // CourseTask queries
      services.AddScoped<IQueryHandlerAsync<CourseTaskQuery, List<CourseTaskQueryModel>>, CourseTaskQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<CourseTaskTotalQuery, int>, CourseTaskQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<CourseTaskDetailsQuery, CourseTaskQueryModel>, CourseTaskQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<CourseTaskAttemptsQuery, List<CourseTaskAttemptQueryModel>>, CourseTaskQueryHandler>();
      services.AddScoped<IQueryHandlerAsync<CourseTaskAttemptDetailsQuery, CourseTaskAttemptDetailsQueryModel>, CourseTaskQueryHandler>();
    }
  }
}