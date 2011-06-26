require 'rubygems'
require 'highline/import'
require 'fileutils'

ROOT_DIR = File.expand_path File.dirname(__FILE__)
HOME_DIR = ENV['HOME']
DIFF  = 'diff -Naur'
PATCH = 'patch -Nsp1 <'
LABEL_WIDTH = 12

# Utility method to print messages. Use the options to specify a color or
# a fixed label width:
#
#   log 'test', 'OK'                       # prints a green [OK] label
#   log 'test', 'error', :color => :red    # prints the label in red
#   log 'test', 'msg', :label_width => 12  # prints a 12-char label
#
def log(msg, label, params = {})
  params = {
    :color       => :green,
    :label_width => :auto
  }.merge(params)
  params[:label_width] = 0 if params[:label_width] == :auto
  say "[<%= color('#{label}', :#{params[:color].to_s.ljust(10)}) %>]".rjust(30 + params[:label_width]) + " #{msg}"
end

# Retrieves the list of config files; accepts a block as input.
# Returns the list of all the config files.
def get_dotfiles
  files = []
  Dir.glob(File.join(ROOT_DIR, 'base', '*'), File::FNM_DOTMATCH) do |f|
    unless f.end_with? '.' or File.directory? f # TODO handle directories
      f = File.basename f
      yield f if block_given?
      files << f
    end
  end
  files
end

# Returns true if a given file has been modified.
def modified?(dotfile)
  actual_diff = diff(dotfile)
  actual_diff = actual_diff.split("\n")[2..-1].join("\n") unless actual_diff.nil? or actual_diff.empty?
  patchfile = File.join(ROOT_DIR, 'patches', dotfile)
  stored_diff = File.exists?(patchfile) ? IO.read(patchfile).split("\n")[2..-1].join("\n") : ''
  return actual_diff != stored_diff
end

# Returns the differences between the current dotfile and the base version.
def diff(dotfile)
  dotfiles = get_dotfiles
  raise ArgumentError if dotfile.nil? or dotfile.empty? or !get_dotfiles.include?(dotfile)
  old_dir = File.join(ROOT_DIR, 'diffs', 'old')
  new_dir = File.join(ROOT_DIR, 'diffs', 'new')
  FileUtils.mkdir_p old_dir
  FileUtils.mkdir_p new_dir
  FileUtils.cp File.join(HOME_DIR, dotfile), new_dir if File.exists? File.join(HOME_DIR, dotfile)
  FileUtils.cp File.join(ROOT_DIR, 'base', dotfile), old_dir
  Dir.chdir File.join(ROOT_DIR, 'diffs')
  `#{DIFF} #{File.join 'old', dotfile} #{File.join 'new', dotfile}`
end

# Writes the contents of a dotfile, applying patches if necessary.
def install(dotfile)
  new_dir = File.join(ROOT_DIR, 'diffs', 'new')
  FileUtils.mkdir_p new_dir
  FileUtils.cp File.join(ROOT_DIR, 'base', dotfile), new_dir
  Dir.chdir new_dir
  patchfile = File.join(ROOT_DIR, 'patches', dotfile)
  system "#{PATCH} #{patchfile}" if File.exists? patchfile
  FileUtils.cp File.join(new_dir, dotfile), HOME_DIR
end

desc 'Returns the diff between the current version of a dotfile and its base version (e.g. rake diff file=.emacs)'
task :diff do
  begin
    puts diff ENV['file']
  rescue ArgumentError
    log "Please specify a valid dotfile, e.g. `rake diff file=.emacs'", 'error', :color => :red
  end
end

desc 'Lists all the config files'
task :list do
  puts
  get_dotfiles do |f|
    if modified? f
      log f, 'modified', :color => :yellow, :label_width => LABEL_WIDTH
    else
      log f, 'OK', :label_width => LABEL_WIDTH
    end
  end
  puts
end

desc 'Synchronizes the local modification with the patches directory'
task :sync do
  puts
  get_dotfiles.each do |f|
    patchfile = File.join(ROOT_DIR, 'patches', f)
    if File.exists? patchfile
      if !agree("Patch file for \`#{f}\' exists. Overwrite? [y/n]")
        log f, 'skipped', :color => :yellow, :label_width => LABEL_WIDTH
        next
      end
    end
    patch_contents = diff(f)
    if patch_contents.nil? or patch_contents.empty?
      log f, 'skipped', :color => :yellow, :label_width => LABEL_WIDTH
    else
      File.open(patchfile, 'w') {|file| file << diff(f)}
      log f, 'written', :label_width => LABEL_WIDTH
    end
  end
  puts
end

desc 'Cleans the patches directory'
task :clean do
  puts
  get_dotfiles do |f|
    patchfile = File.join(ROOT_DIR, 'patches', f)
    next unless File.exists? patchfile
    FileUtils.rm patchfile
    log f, 'deleted', :label_width => LABEL_WIDTH
  end
  ['old', 'new'].each do |d| 
    if File.exists? File.join(ROOT_DIR, 'diffs', d)
      FileUtils.rm_r File.join(ROOT_DIR, 'diffs', d)
      log "diffs/#{d}", 'deleted', :label_width => LABEL_WIDTH
    end
  end
  puts
end

desc 'Installs the config files to the home directory'
task :install do
  get_dotfiles do |f|
    if File.exists? File.join(HOME_DIR, f)
      unless agree "Config file \`#{f}\' already exists. Overwrite? [y/n]"
        log f, 'skipped', :color => :yellow, :label_width => LABEL_WIDTH
        next
      end
    end
    install(f)
    log f, 'written', :label_width => LABEL_WIDTH
  end
end

task :default => :list
