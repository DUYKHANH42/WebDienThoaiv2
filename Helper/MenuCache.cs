using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WebDienThoai.Models;
using WebDienThoai.Services;

namespace WebDienThoai.Helper
{
    public class MenuCache
    {
        public static List<MenuLoai> GetMenu()
        {
            var app = HttpContext.Current.Application;

            if (app["MENU"] == null)
            {
                MenuService service = new MenuService();
                app["MENU"] = service.BuildMenu();
            }

            return (List<MenuLoai>)app["MENU"];
        }

        public static void ClearMenu()
        {
            HttpContext.Current.Application["MENU"] = null;
        }

    }
}