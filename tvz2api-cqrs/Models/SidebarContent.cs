﻿using System;
using System.Collections.Generic;

namespace tvz2api_cqrs.Models
{
    public partial class SidebarContent
    {
        public SidebarContent()
        {
            SidebarContentFile = new HashSet<SidebarContentFile>();
        }

        public int Id { get; set; }
        public string Title { get; set; }
        public int? CourseId { get; set; }

        public virtual Course Course { get; set; }
        public virtual ICollection<SidebarContentFile> SidebarContentFile { get; set; }
    }
}
