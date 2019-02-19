using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using lab_17_07.Models;

namespace lab_17_07.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult Index(string id)
        {
            //Console.Out.WriteLine("hola"+id);
           // return Json(new {
           //     val = "123",
           //     val2 = "12312312"
           // });
          // return Content("watashi");
            return View();
        }

        public IActionResult About()
        {
            ViewData["Message"] = "Your application description page.";

            return View();
        }

        public IActionResult Contact()
        {
            ViewData["Message"] = "Your contact page.";

            return View();
        }

        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
