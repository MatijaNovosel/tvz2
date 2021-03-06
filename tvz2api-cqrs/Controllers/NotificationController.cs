using tvz2api_cqrs.Models;
using tvz2api_cqrs.Infrastructure.Commands;
using tvz2api_cqrs.Enumerations;
using tvz2api_cqrs.Implementation.Queries;
using tvz2api_cqrs.Implementation.Commands;
using tvz2api_cqrs.QueryModels;
using tvz2api_cqrs.Infrastructure.Messaging;
using tvz2api_cqrs.Implementation.Specifications;
using Microsoft.AspNetCore.Mvc;
using tvz2api_cqrs.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.SignalR;
using tvz2api_cqrs.Hubs;
using tvz2api_cqrs.Custom;
using Microsoft.AspNetCore.Http;
using tvz2api_cqrs.Models.DTO;
using Microsoft.AspNetCore.Authorization;
using tvz2api_cqrs.Custom.Attributes;

namespace tvz2api_cqrs.Controllers
{
  [Authorize]
  [Route("api/[controller]")]
  [ApiController]
  public class NotificationController : ControllerBase
  {
    private readonly ICommandBus _commandBus;
    private readonly IQueryBus _queryBus;
    private readonly IUserResolver _userResolver;
    private readonly IHubContext<NotificationHub> _hubContext;

    public NotificationController(ICommandBus commandBus, IQueryBus queryBus, IHubContext<NotificationHub> notificationHub, IUserResolver userResolver)
    {
      _commandBus = commandBus;
      _queryBus = queryBus;
      _hubContext = notificationHub;
      _userResolver = userResolver;
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetDetails(int id)
    {
      var result = await _queryBus.ExecuteAsync(new NotificationQuery(id));
      return Ok(result);
    }

    [HttpGet("user/{userId}")]
    public async Task<IActionResult> GetUserNotifications(int userId)
    {
      var result = await _queryBus.ExecuteAsync(new NotificationUserQuery(userId));
      return Ok(result);
    }

    [HttpGet("user-total/{userId}")]
    public async Task<IActionResult> GetUserNotificationsTotal(int userId)
    {
      var result = await _queryBus.ExecuteAsync(new NotificationUserTotalQuery(userId));
      return Ok(result);
    }

    [HttpPost]
    public async Task<IActionResult> CreateNew(int courseId, [FromForm] NotificationCreateCommand command)
    {
      if (!_userResolver.HasCoursePrivilege(courseId, new List<PrivilegeEnum>() { PrivilegeEnum.CanManageCourse, PrivilegeEnum.CanManageNotifications }))
      {
        return Unauthorized();
      }
      await _commandBus.ExecuteAsync(command);
      await _hubContext.Clients.All.SendAsync("newNotification");
      return Ok();
    }

    [HttpPost("seen")]
    public async Task<IActionResult> Seen(NotificationSeenCommand command)
    {
      await _commandBus.ExecuteAsync(command);
      return Ok();
    }

    [HttpPost("archive")]
    public async Task<IActionResult> Archive(int courseId, NotificationArchiveCommand command)
    {
      if (!_userResolver.HasCoursePrivilege(courseId, new List<PrivilegeEnum>() { PrivilegeEnum.CanManageCourse, PrivilegeEnum.CanManageNotifications, PrivilegeEnum.CanArchiveNotifications }))
      {
        return Unauthorized();
      }
      await _commandBus.ExecuteAsync(command);
      return Ok();
    }

    [HttpDelete]
    public async Task<IActionResult> Delete(int courseId, int id)
    {
      if (!_userResolver.HasCoursePrivilege(courseId, new List<PrivilegeEnum>() { PrivilegeEnum.CanManageCourse, PrivilegeEnum.CanManageNotifications, PrivilegeEnum.CanDeleteNotifications }))
      {
        return Unauthorized();
      }
      await _commandBus.ExecuteAsync(new NotificationDeleteCommand()
      {
        CourseId = courseId,
        Id = id
      });
      await _hubContext.Clients.All.SendAsync("deleteNotification");
      return Ok();
    }
  }
}