# TRP Backup
In order to get the backup started, clone this respository, then do:

`bundle install`
`ruby trp.rb`

## Note
Because of the Reddit API limits, there's a 2 second sleep after each
call that makes the script run for about 2 hours. If it crashes (it
might), just run `ruby trp.rb` again and it picks up from where it left
of.

## Contributing
Feel free to make changes, I will merge pull requests that make sense.

## Ugly code
Yes, it's ugly, but at this point my main concern is to store as much
data as possible given the fact that we might be shutdown from Reddit.

## Improvements I want to make
- Loop through the saved data, get the authors of each post
- Check each author's contributions if matches trp
- Download those posts also
