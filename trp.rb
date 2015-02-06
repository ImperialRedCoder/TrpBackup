require 'redditkit'
require 'awesome_print'
require 'yaml'

# global
$files = []
$file_path = Dir.pwd + '/files.txt'

def getStorageDir
  storage_dir = Dir.pwd + "/" + "storage"
  if !File.directory?(storage_dir)
    Dir.mkdir(storage_dir)
  end
  
  storage_dir
end

def log_id(id)
  $files.push(id)
  File.open($file_path, 'a+') {|f| f.write("\n#{id}") }
end

def check_id_saved(id)
  if $files.count == 0 
    # create file if it doesn't exist
    if !File.exists?($file_path)
      File.open($file_path, "w") {}
    end
      
    $files = File.readlines($file_path).each { |l| l.chomp! }
  end
  
  return $files.include?(id)
end

def crawl(subreddit, category = nil, after = nil)
  
  time = nil
  if category.nil?
    category = 'hot'
    time = 'day'
  else category == 'top'
    time = 'all'
  end
  
  links = RedditKit.links(subreddit, { :after => after, :category => category, :time => time })
  
  links.each do |link|
    if check_id_saved(link.id)
      ap "ID #{link.id} already saved, skipping"
      next
    end
    
    ap "Saving ID #{link.id}: #{link.title}"
    
    result = {
      :link => link,
      :comments => RedditKit.comments(link)
    }
    
    File.open(getStorageDir + '/' + link.id + '.txt', 'w') {|f| f.write(YAML.dump(result)) }
    
    log_id(link.id)
  
    sleep 2
  end
  
  if !links.after.nil?
    crawl(subreddit, category, links.after)
  else 
    ap "\n\nAll done.\n\n"
  end
end

trp = RedditKit.subreddit('theredpill')

ap "Starting downloading the current content of the subreddit (1000 posts)"
crawl(trp)

ap "Starting to download the top posts"
crawl(trp, 'top', nil)
