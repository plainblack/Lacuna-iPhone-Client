require 'ftools'

def syncDirs(sourceDirName, targetDirName)
  Dir.foreach(sourceDirName) do |x|
    sourcePathName = "#{sourceDirName}/#{x}";
    targetPathName = "#{targetDirName}/#{x}";
    if File.exists?(targetPathName)
      if File.directory?(sourcePathName)
        if x != "." && x != ".." && x != ".DS_Store" && x != ".git"
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
      if x != "400" && x != "300" && x != "50" && !( (sourceDirName =~ /planet_side$/) && (x =~ /[0-9].png$/) ) && x != "ui RyanKnope" && x != "ui" && x != "web ui" && x != ".git"
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

def cleanDirs(toCleanDirName, masterDirName)
  Dir.foreach(toCleanDirName) do |x|
    toCleanPathName = "#{toCleanDirName}/#{x}";
    masterPathName = "#{masterDirName}/#{x}";
    if File.exists?(masterPathName)
      if File.directory?(toCleanPathName)
        if x != "." && x != ".." && x != ".DS_Store" && x != ".git"
          cleanDirs(toCleanPathName, masterPathName)
        end
      end
    else
      if x != "resources.json" && x != ".DS_Store" && x != ".git"
        if File.directory?(toCleanPathName) 
          puts "#{toCleanPathName} is missing from master"
          #Dir.mkdir(masterPathName)
        else
          puts "#{toCleanPathName} is missing from master"
          #File.copy(toCleanPathName, masterPathName)
        end
      end
    end
  end
end

def getNewResources()
  exec "curl http://pt.lacunaexpanse.com/resources.json > UniversalClient/assets/resources.json"
end

syncDirs("/users/rundeks/Dropbox/space game/iphone ui", "/users/rundeks/dev/iPhone/Lacuna-iPhone-Client/UniversalClient/assets/iphone ui")
syncDirs("../Lacuna-Assets", "/users/rundeks/dev/iPhone/Lacuna-iPhone-Client/UniversalClient/assets")

cleanDirs("/users/rundeks/dev/iPhone/Lacuna-iPhone-Client/UniversalClient/assets/iphone ui", "/users/rundeks/Dropbox/space game/iphone ui")
cleanDirs("/users/rundeks/dev/iPhone/Lacuna-iPhone-Client/UniversalClient/assets", "../Lacuna-Assets")

getNewResources()