using Microsoft.AspNetCore.Mvc;
using Notes.Server.Models;

namespace Notes.Server.Controllers;

[ApiController]
[Route("api/[controller]")]
public class PersonController : ControllerBase
{
    static readonly List<Person> _person = new();


    [HttpGet]
    public IActionResult GetAll()
    {
        return Ok(_person);
    }

    [HttpPost()]
    public IActionResult AddPerson([FromBody] Person person)
    {
        if (person == null) return BadRequest();
        _person.Add(person);
        return Ok(person);
    }
}
