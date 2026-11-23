{ pkgs, ... }:

{
  programs.newsboat = {
    enable = true;
    urls = [
      {
        url = "https://www.is.fi/rss/tuoreimmat.xml";
        tags = [ "news-fi" ];
      }
      {
        url = "https://www.hs.fi/rss/tuoreimmat.xml";
        tags = [ "news-fi" ];
      }
      {
        url = "https://www.yle.fi/rss/uutiset/paauutiset";
        tags = [ "news-fi" ];
      }
      {
        url = "https://reddit.com/r/suomi/.rss";
        tags = [ "tech" ];
      }
      {
        url = "https://www.theregister.com/headlines.atom";
        tags = [ "tech" ];
      }
      {
        url = "https://hnrss.org/frontpage";
        tags = [ "tech" ];
      }
      {
        url = "https://hnrss.org/newest";
        tags = [ "tech" ];
      }
      {
        url = "https://reddit.com/r/programming/.rss";
        tags = [ "tech" ];
      }
    ];
  }; 
}
