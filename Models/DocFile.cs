﻿using System;
namespace interpolapi.Models
{
	public class DocFile
	{
		public int DocFileId { get; set; }

		public string Title { get; set; }

		public string? UserId { get; set; }

		public User? User { get; set; }

		public ICollection<Moveable>? Moveables { get; set; }

		public ICollection<Panel>? Panels { get; set; }
	}
}

