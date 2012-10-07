require 'digest'

module GitRunner
  class Instruction

    # Performs deployments using capistrano (cap deploy)
    class Deploy < Base
      attr_accessor :clone_directory


      def should_run?
        branches.empty? || branches.include?(branch.name)
      end

      def perform
        start_time = Time.now

        Text.out(Text.green("Performing Deploy (#{environment_from_branch(branch)})"), :heading)

        checkout_branch

        if missing_capfile?
          Text.out(Text.red("Missing Capfile, unable to complete deploy."))
          fail!
        end

        prepare_deploy_environment
        perform_deploy
        cleanup_deploy_environment

        end_time = Time.now

        Text.out(Text.green("\u2714 Deploy successful, completed in #{(end_time - start_time).ceil} seconds"))
      end

      def branches
        args.split(/\s+/)
      end

      def missing_capfile?
        !File.exists?("#{clone_directory}/Capfile")
      end

      def uses_bundler?
        File.exists?("#{clone_directory}/Gemfile")
      end

      def multistage?
        result = execute("grep -e 'require.*capistrano.*multistage' #{clone_directory}/#{Configuration.instruction_file} || true")
        !result.empty?
      end

      def checkout_branch
        timestamp            = Time.now.strftime("%Y%m%d%H%M%S")
        self.clone_directory = File.join(Configuration.tmp_directory, "#{branch.repository_name}-#{environment_from_branch(branch)}-#{timestamp}")

        Text.out("Checking out #{branch.name} to #{clone_directory}")

        execute(
          "mkdir -p #{clone_directory}",
          "git clone --depth=1 --branch=#{branch.name} file://#{branch.repository_path} #{clone_directory}"
        )
      end

      def prepare_deploy_environment
        Text.out("Preparing deploy environment")

        if uses_bundler?
          execute(
            "cd #{clone_directory}",
            "bundle install --path=#{File.join(Configuration.tmp_directory, '.gems')}"
          )
        end
      end

      def perform_deploy
        cap_deploy_command = if multistage?
          Text.out("Deploying application (multistage detected)")
          "cap #{environment_from_branch(branch)} deploy"
        else
          Text.out("Deploying application")
          "cap deploy"
        end

        execute(
          "cd #{clone_directory}",
          cap_deploy_command
        )
      end

      def cleanup_deploy_environment
        Text.out("Cleaning deploy environment")
        execute("rm -rf #{clone_directory}")
      end


    private
      def environment_from_branch(branch)
        if branch.name == 'master'
          'production'
        else
          branch.name
        end
      end
    end
  end
end
