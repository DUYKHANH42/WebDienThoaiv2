using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace WebDienThoai.DAO
{
    public class MauSacDAO
    {
        string connStr = ConfigurationManager
                      .ConnectionStrings["DienThoaiDBConnectionString"]
                      .ConnectionString;


    }
}