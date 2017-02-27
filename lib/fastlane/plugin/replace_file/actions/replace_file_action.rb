module Fastlane
    module Actions
        class ReplaceFileAction < Action
            def self.run(params)
                old_file_absolute_path = File.expand_path(params[:path_to_old_file])
                new_file_absolute_path = File.expand_path(params[:path_to_new_file])

                UI.user_error!("ERROR - New file not found at location: '#{new_file_absolute_path}'") unless File.exist?(new_file_absolute_path)
                UI.user_error!("ERROR - Old file not found at location: '#{old_file_absolute_path}'") unless File.exist?(old_file_absolute_path)

                old_file_path = File.dirname(old_file_absolute_path)
                UI.message("Path to project file parent folder: '#{old_file_path}'")

                new_file_path = File.dirname(new_file_absolute_path)
                UI.message("Path to replacement file parent folder: '#{new_file_path}'")

                old_file_name = File.basename(old_file_absolute_path)
                UI.message("Old file name: '#{old_file_name}'")

                UI.message("Renaming new file...")
                begin
                    File.rename(new_file_absolute_path, "#{new_file_path}/#{old_file_name}")
                rescue SystemCallError
                    UI.error("There was a problem renaming the new file.")
                else
                    UI.success("File succesfully renamed to '#{old_file_name}'")
                    new_file_absolute_path = "#{new_file_path}/#{old_file_name}"
                    UI.success("New file now located at: '#{new_file_absolute_path}'")
                end

                UI.message("Moving new file to correct location in project...")
                begin
                    FileUtils.mv(new_file_absolute_path, old_file_path)
                rescue => exception
                    UI.error(exception)
                    UI.user_error!("There was a problem moving the new file from '#{new_file_absolute_path}' to '#{old_file_path}'")
                else
                    UI.success("File replacement finished!") unless File.exist?(new_file_absolute_path)
                end
            end

            def self.description
                "Replace any file in your mobile project"
            end

            def self.authors
                ["Jonathan Ritchie"]
            end

            def self.details
                "This plugin simply allows you to replace any file in your project with a new one. You can set the filenames to be the same if necessary"
            end

            def self.available_options
                [
                    FastlaneCore::ConfigItem.new(key: :path_to_old_file,
                        env_name: "PATH_TO_OLD_FILE",
                        description: "The location of the file which is to be replaced in your project",
                        optional: false,
                    type: String),
                    FastlaneCore::ConfigItem.new(key: :path_to_new_file,
                        env_name: "PATH_TO_NEW_FILE",
                        description: "The location to the new file",
                        optional: false,
                    type: String)
                ]
            end

            def self.is_supported?(platform)
                [:ios, :mac, :android].include?(platform)
            end
        end
    end
end
