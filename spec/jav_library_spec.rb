RSpec.describe JavLibrary do
  client = JavLibrary::Client.new
  client.load "RVG-081"

  it "finds title" do
    expect(client.title).to eq("Anal Device Bondage Iron Restraint Anal Torture BEST Vol.1")
  end

  it "finds cast" do
    cast = ["Mitsuna Rei", "Hoshikawa Maki", "Nishita Karina", "Momose Yuri", "Onodera Risa", "Kanou Hana", "Kuroki Ikumi", "Oosaki Himeri"]
    expect(client.cast).to eq(cast)
  end

  it "finds cover" do
    cover = "https://pics.dmm.co.jp/mono/movie/adult/13rvg081/13rvg081pl.jpg"
    expect(client.cover).to eq(cover)
  end

  it "finds release date" do
    release_date = "2018-11-15"
    expect(client.release_date).to eq(release_date)
  end

  it "finds genres" do
    genres = ["Restraint", "Enema", "Best, Omnibus", "4HR+"]
    expect(client.genres).to eq(genres)
  end

  client.close
end
