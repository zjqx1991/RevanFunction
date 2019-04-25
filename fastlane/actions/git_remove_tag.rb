module Fastlane
  module Actions
    module SharedValues
      GIT_REMOVE_TAG_CUSTOM_VALUE = :GIT_REMOVE_TAG_CUSTOM_VALUE
    end

    class GitRemoveTagAction < Action
      def self.run(params)

        is_removeLocalTag = params[:rmLocalTag]
        is_removeRemoteTag = params[:rmRemoteTag]
        tagName = params[:tag]

        #1、定义数组存放需要执行的命令
        cmds = []

        #2、往数组里面, 添加相应的命令
        # 2.1、删除本地tag
        # git tag -d 标签名称
        if is_removeLocalTag
          cmds << "git tag -d #{tagName} "
        end

        # 2.2、删除远程tag
        if is_removeRemoteTag
          cmds << " git push origin :#{tagName}"
        end

        #3、执行数组里面的所有命令
        result = Actions.sh(cmds.join('&'))
        return result
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "删除本题tag以及远程tag"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "如果检测到本地tag#{tagName}存在，删除本地tag#{tagName}及其远程tag#{tagName}"
      end

      def self.available_options
        # Define all options your action supports. 
        
        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :tag,
                                       description: "需要被删除的标签名称", 
                                       optional: false,
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :rmLocalTag,
                                       description: "是否需要删除本地标签", 
                                       optional: true,
                                       is_string: false,
                                       default_value: true),
          FastlaneCore::ConfigItem.new(key: :rmRemoteTag,
                                       description: "是否需要删除远程标签", 
                                       optional: true,
                                       is_string: false,
                                       default_value: true)
        ]
      end

      def self.output
      end

      def self.return_value
        nil
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["Revan(zjqx1991@163.com)"]
      end

      def self.is_supported?(platform)
        # you can do things like
        # 
        #  true
        # 
        #  platform == :ios
        # 
        #  [:ios, :mac].include?(platform)
        # 

        platform == :ios
      end
    end
  end
end
