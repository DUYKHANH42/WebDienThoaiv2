using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;

namespace WebDienThoai.Helper
{
    public class EmailHelper
    {
        public static void Send(string toEmail, string subject, string body)
        {
            var fromEmail = "kxtduykhanh@gmail.com";
            var password = "upjw zqhr ajsv fpxp";

            MailMessage mail = new MailMessage();
            mail.From = new MailAddress(fromEmail, "Web Điện Thoại");
            mail.To.Add(toEmail);
            mail.Subject = subject;
            mail.Body = body;
            mail.IsBodyHtml = true;

            SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
            smtp.Credentials = new NetworkCredential(fromEmail, password);
            smtp.EnableSsl = true;

            smtp.Send(mail);
        }
    }
}
