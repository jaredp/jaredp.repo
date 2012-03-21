import re

def youtube_embed_code(url, video_id):
    return '<iframe width="230" height="230" src="http://www.youtube.com/embed/%s" frameborder="0" allowfullscreen></iframe>' % video_id

def image_embed_code(url):
    print 'this is an image'
    return '<img src="%s" />' % url

embeddable_url_patterns = (
    (r'^http://(?:www.)?youtube.com/watch\?(.*&)*v=(?P<video_id>[-_a-zA-Z0-9]*)', youtube_embed_code),
    (r'.*(?i)(jpg|jpeg|gif|bmp|png|tiff)', image_embed_code),
)

def embed_code_for_url(matchobj):
    url = matchobj.groupdict()['url']
        
    for pattern in embeddable_url_patterns:
        regex, function = pattern
        match = re.match(regex, url)
        if match:
            args = match.groupdict()
            args['url'] = url
            code = function(**args)
            if code:
                return code

    return matchobj.group()

from django.utils.html import escape, urlize
from django.template.defaultfilters import linebreaks

def html_from_text(text):
    linkified = urlize(escape(text))
    markedup = re.sub(r'<a href="(?P<url>.*?)".*?</a>', embed_code_for_url, linkified)
    return linebreaks(markedup)

if __name__ == "__main__":
    print html_from_text('foobar')
    print html_from_text('http://google.com')
    print html_from_text('an image (with an <img> tag) http://blah.com/image.jpg')
    print html_from_text('youtube vid: http://www.youtube.com/watch?v=LYuZHNP8wLg&feature=player_embedded')
    print html_from_text('(alternatively, http://fuckyeahygotas.tumblr.com/post/5112873028/non-stop-nyeh-cat which shows http://www.youtube.com/watch?v=LYuZHNP8wLg&feature=player_embedded)')
