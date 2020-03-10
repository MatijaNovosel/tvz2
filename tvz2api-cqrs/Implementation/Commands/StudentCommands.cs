using tvz2api_cqrs.Infrastructure.Commands;
using System;
using System.Collections.Generic;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace tvz2api_cqrs.Implementation.Commands
{
  public class StudentUpdatePretplataCommand : ICommand
  {
    public StudentUpdatePretplataCommand() { }
    public StudentUpdatePretplataCommand(int studentId, string password, int kolegijId)
    {
      StudentId = studentId;
      Password = password;
      KolegijId = kolegijId;
    }
    public int StudentId { get; set; }
    public string Password { get; set; }
    public int KolegijId { get; set; }
  }
}