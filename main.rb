require 'securerandom'
require 'sinatra'
require 'sqlite3'
require 'sinatra/json'
db = SQLite3::Database.new "pixiv_clone.db"
db.results_as_hash = true

get '/' do #top page
  @posts = db.execute("select * from posts")

  erb :index

end

post'/'do

@name=@params[:ex_text]
p "#{@name}"

if params["file"][:type].include?"jpeg"
  ext = "jpg"
elsif params["file"][:type].include?"png"
  ext = "png"

end



file_name = SecureRandom.hex + "." + ext

FileUtils.mv(params["file"][:tempfile],"./public/uploads/" + file_name)

stmt = db.prepare("INSERT INTO posts (text,img_file_name) VALUES (?,?)")
stmt.bind_params(@name, file_name)

stmt.execute
@posts = db.execute("select * from posts")



# @aaa = db.execute("insert into posts (text, img_file_name) values ('#{@name}', ‘img1.png’ );")

erb :index

end


get '/star' do
  post_id = params["post_id"].to_i
  post = db.execute("SELECT star_count FROM posts WHERE id = ?",post_id)

  new_star_count = post[0]["star_count"] + 35439
  db.execute("UPDATE posts SET star_count = ? WHERE id =?",new_star_count,post_id)
  return "【すたあついた】"
end
