namespace Notes.Server.Models;

public class Person 
{
    public required string Name { get; set; }
    public int Age { get; set; }

    public override string ToString() => $"Name: {Name}\nAge: {Age}\n";
    
}