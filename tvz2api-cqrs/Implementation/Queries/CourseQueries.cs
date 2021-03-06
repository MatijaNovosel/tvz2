using System.Security.AccessControl;
using tvz2api_cqrs.Common;
using tvz2api_cqrs.QueryModels;
using tvz2api_cqrs.Infrastructure.Queries;
using tvz2api_cqrs.Infrastructure.Specifications;
using tvz2api_cqrs.Implementation.Specifications;
using System.Collections.Generic;
using tvz2api_cqrs.Models.DTO;

namespace tvz2api_cqrs.Implementation.Queries
{
  public class CourseQuery : IQuery<List<CourseQueryModel>>
  {
    public CourseQuery() { }
    public CourseQuery(CourseSpecification specification)
    {
      Specification = specification;
    }
    public CourseQuery(QueryOptions queryOptions, CourseSpecification specification)
    {
      QueryOptions = queryOptions;
      Specification = specification;
    }
    public QueryOptions QueryOptions { get; set; }
    public CourseSpecification Specification { get; set; }
  }

  public class CourseDetailsQuery : IQuery<CourseDetailsQueryModel>
  {
    public CourseDetailsQuery(int id)
    {
      Id = id;
    }
    public int Id { get; set; }
  }

  public class CourseUserGradesQuery : IQuery<CourseUserGradesQueryModel>
  {
    public CourseUserGradesQuery(int userId, int courseId)
    {
      UserId = userId;
      CourseId = courseId;
    }
    public int UserId { get; set; }
    public int CourseId { get; set; }
  }

  public class CourseSidebarQuery : IQuery<List<SidebarContentDTO>>
  {
    public CourseSidebarQuery(int id)
    {
      Id = id;
    }
    public int Id { get; set; }
  }

  public class CourseLandingPageQuery : IQuery<string>
  {
    public CourseLandingPageQuery(int courseId)
    {
      CourseId = courseId;
    }
    public int CourseId { get; set; }
  }

  public class CourseDiscussionRepliesQuery : IQuery<List<DiscussionReplyDTO>>
  {
    public CourseDiscussionRepliesQuery(int discussionId)
    {
      DiscussionId = discussionId;
    }
    public int DiscussionId { get; set; }
  }

  public class CourseDiscussionsQuery : IQuery<List<DiscussionDTO>>
  {
    public CourseDiscussionsQuery(int courseId, bool sortByNewer)
    {
      CourseId = courseId;
      SortByNewer = sortByNewer;
    }
    public int CourseId { get; set; }
    public bool SortByNewer { get; set; }
  }

  public class CourseTotalQuery : IQuery<int>
  {
    public CourseTotalQuery(CourseSpecification specification)
    {
      Specification = specification;
    }
    public CourseTotalQuery() { }
    public CourseSpecification Specification { get; set; }
  }

  public class UserCourseQuery : IQuery<List<UserCourseDetailsDTO>>
  {
    public UserCourseQuery(int id, CourseUserSpecification specification)
    {
      Id = id;
      Specification = specification;
    }
    public int Id { get; set; }
    public CourseUserSpecification Specification { get; set; }
  }

  public class UserCourseTotalQuery : IQuery<int>
  {
    public UserCourseTotalQuery(int id, CourseUserSpecification specification)
    {
      Id = id;
      Specification = specification;
    }
    public int Id { get; set; }
    public CourseUserSpecification Specification { get; set; }
  }

  public class CourseNotificationsQuery : IQuery<List<NotificationQueryModel>>
  {
    public CourseNotificationsQuery() { }
    public CourseNotificationsQuery(CourseNotificationsSpecification specification)
    {
      Specification = specification;
    }
    public bool SortByNew { get; set; }
    public CourseNotificationsSpecification Specification { get; set; }
  }
}
