from flask import Flask, render_template, request
import urllib.request, json

app = Flask(__name__)


class Result(object):
    id = 0
    text = ""

    def __init__(self, id,title,summary, date, location,parties,eventType,url):
        self.id = id
        self.title = title
        self.summary = summary
        self.date = date
        self.location = location
        self.parties = parties
        self.eventType = eventType
        self.url = url


@app.route("/")
def index():
    return render_template("index.html")


@app.route('/', methods=['POST'])
def my_form_post():
    print("search called")
    timePeriod = request.form.get('dateSelector')
    if timePeriod == "lastweek":
        timeQ = "&fq=SOLR_DATE:[NOW-7DAY/DAY%20TO%20NOW]"
    elif timePeriod == "lastmonth":
        timeQ = "&fq=SOLR_DATE:[NOW-1MONTH/MONTH%20TO%20NOW]"
    elif timePeriod == "last6month":
        timeQ = "&fq=SOLR_DATE:[NOW-6MONTH/MONTH%20TO%20NOW]"
    else:
        timeQ = ""

    countries = request.form.getlist("country")
    if len(countries) == 0:
        countryQ = ""
    else:
        countryQ = "COUNTRY:" + "%20OR%20".join(countries)
    topics = request.form.getlist("topic")
    if len(topics) == 0:
        topicQ = ""
    else:
        topicQ = "&fq=EVENT_TYPE:" + "%20OR%20".join(topics)

    text = ""
    #url = u"http://3.14.15.35:8999/solr/AIR_May6_2/select?debug=true&fq="+countryQ+topicQ+timeQ+"&indent=true&q=*:*&rows=100&wt=json"
    url = u"http://18.191.160.114:8999/solr/AIR_May6_5/select?debug=true&fq="+countryQ+topicQ+timeQ+"&sort=SORT_DATE%20desc"+"&indent=true&q=*:*&rows=100&wt=json"
    print(url)
    top10=[]

    with urllib.request.urlopen(url) as url:
        data = json.loads(url.read().decode())
    top10 = []
    print(len(data['response']['docs']))
    for each in range(0, len(data['response']['docs'])):
        try:
         #print(data['response']['docs'][each])
         title= data['response']['docs'][each]['TITLE'][0]
         #print('title: '+title)
         summary = data['response']['docs'][each]['SUMMARY'][0]
         #print('summary: '+summary)
         date = data['response']['docs'][each]['EVENT_DATE'][0]
         #print('date: '+date)
         location = data['response']['docs'][each]['LOCATION'][0]
         #print('location: '+location)
         parties = data['response']['docs'][each]['ORG_PARTIES'][0]
         #print('parties: '+parties)
         eventType = data['response']['docs'][each]['EVENT_TYPE'][0]
         #print('eventType: '+eventType)
         url = data['response']['docs'][each]['URL'][0]
         #print('url: '+url)
         top10.append(Result(data['response']['docs'][each]['id'],title,summary,date,location,parties,eventType,url))
        except:
            print('Error occurred')
    return render_template("index.html", result=top10)


if __name__ == "__main__":
    app.run()
