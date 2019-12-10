using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace kafka.reqrep.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class RequetesController : Controller
    {
        private readonly IHttpClientFactory _clientFactory;

        public RequetesController(IHttpClientFactory clientFactory)
        {
            _clientFactory = clientFactory;
        }

        [HttpGet("{id}")]
        public async Task<string> GetAsync(int id)
        {
            string ksql = "{\"ksql\": \"select * from REPONSES_FCT1 where idCorrelation='3' EMIT CHANGES;\"}";

            HttpContent c = new StringContent(ksql, Encoding.UTF8, "application/vnd.ksql.v1+json");

            var request = new HttpRequestMessage(HttpMethod.Post,
            "query");

            request.Content = c;

            var client = _clientFactory.CreateClient("ksqldb");

            //var response = await client.SendAsync(request);

            string retour = "";

            using (var response = await client.SendAsync(
                request,
                HttpCompletionOption.ResponseHeadersRead))
                    {
                        using (var body = await response.Content.ReadAsStreamAsync())
                        using (var reader = new StreamReader(body))
                            while (!reader.EndOfStream)
                        retour += reader.ReadLine();
                    }

            //var responseStream = await response.Content.ReadAsStreamAsync();
            //return await JsonSerializer.DeserializeAsync
            //<string>(responseStream);
            return "2";
        }
    }
}
