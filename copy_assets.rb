require 'ftools'

def syncDirs(sourceDirName, targetDirName)
  Dir.foreach(sourceDirName) do |x|
    sourcePathName = "#{sourceDirName}/#{x}";
    targetPathName = "#{targetDirName}/#{x}";
    if File.exists?(targetPathName)
      if File.directory?(sourcePathName)
        if x != "." && x != ".." && x != ".DS_Store"
          syncDirs(sourcePathName, targetPathName)
        end
      else
        sourceTime = File.mtime(sourcePathName)
        targetTime = File.mtime(targetPathName)
        if sourceTime > targetTime
          puts "#{sourcePathName} is newer: #{sourceTime} : #{targetTime} copying"
          File.copy(sourcePathName, targetPathName)
        end
      end
    else
      if x != "400" && x != "300" && !( (sourceDirName =~ /planet_side$/) && (x =~ /[0-9].png$/) ) && x != "ui RyanKnope" && x != "ui" && x != "web ui"
        if File.directory?(sourcePathName) 
          puts "#{sourcePathName} is missing, making"
          Dir.mkdir(targetPathName)
          syncDirs(sourcePathName, targetPathName)
        else
          puts "#{sourcePathName} is missing, coping it over"
          File.copy(sourcePathName, targetPathName)
        end
      end
    end
  end
end

syncDirs("/users/rundeks/Dropbox/space game/iphone ui", "/users/rundeks/dev/iPhone/Lacuna-iPhone-Client/UniversalClient/assets/iphone ui")