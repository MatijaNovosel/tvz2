using tvz2api_cqrs.Models;
using tvz2api_cqrs.Infrastructure.Commands;
using tvz2api_cqrs.Implementation.Queries;
using tvz2api_cqrs.Implementation.Commands;
using tvz2api_cqrs.QueryModels;
using tvz2api_cqrs.Infrastructure.Messaging;
using tvz2api_cqrs.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using tvz2api_cqrs.Custom;
using Microsoft.AspNetCore.Authorization;

namespace tvz2api_cqrs.Controllers
{
  [Authorize]
  [Route("api/[controller]")]
  [ApiController]
  public class FileController : ControllerBase
  {
    private readonly ICommandBus _commandBus;
    private readonly IQueryBus _queryBus;

    public FileController(ICommandBus commandBus, IQueryBus queryBus)
    {
      _commandBus = commandBus;
      _queryBus = queryBus;
    }

    [HttpPost("upload")]
    public async Task<IActionResult> UploadFiles(List<IFormFile> files)
    {
      if (files == null || files.Count == 0)
      {
        throw new Exception("No files present!");
      }
      var uploadedFileIds = await _commandBus.ExecuteAsync<List<int>>(new FileUploadCommand(files));
      return Ok(uploadedFileIds);
    }

    [HttpPost("upload-sidebar/{sidebarId}")]
    public async Task<IActionResult> UploadFiles([FromForm] List<IFormFile> files, int sidebarId)
    {
      if (files == null || files.Count == 0)
      {
        throw new Exception("No files present!");
      }
      var uploadedFileIds = await _commandBus.ExecuteAsync<List<int>>(new FileUploadSidebarCommand(sidebarId, files));
      return Ok(uploadedFileIds);
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id)
    {
      await _commandBus.ExecuteAsync(new FileDeleteCommand(id));
      return NoContent();
    }

    [HttpGet("sidebar/{id}")]
    public async Task<IActionResult> Get(int id)
    {
      var files = await _queryBus.ExecuteAsync(new FileQuery(id));
      return Ok(files);
    }

    [HttpGet("download-multiple")]
    public async Task<IActionResult> DownloadMultiple([FromQuery(Name = "fileIds[]")] List<int> fileIds)
    {
      var zip = await _queryBus.ExecuteAsync(new FileDownloadMultipleQuery()
      {
        FileIds = fileIds
      });
      return Ok(zip);
    }
  }
}