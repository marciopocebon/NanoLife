Gem::Specification.new do |s|
  s.name        = 'nanolife'
  s.version     = '1.0.0'
  s.executables << 'nanolife'
  s.date        = '2016-11-19'
  s.summary     = "John Conway's Game of Life"
  s.description = "John Conway's Game of Life implemented using Gosu"
  s.authors     = ["NanoDano"]
  s.email       = 'nanodano@devdungeon.com'
  s.files       = ["lib/NanoLife.rb"]
  s.add_runtime_dependency 'gosu', '~> 0.10', '>= 0.10.7'
  s.homepage    = 'https://github.com/DevDungeon/NanoLife'
  s.license     = 'MIT'
end