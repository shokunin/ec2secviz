#Configuration information
module Secviz
  class Config
  require File.join(File.dirname(__FILE__), '..', '..', 'conf', 'environment')

    def accounts
      @@ec2conf.keys
    end

    def use_account(account_name)
      @@ec2conf[account_name]
    end

    def all_accounts
      all_ec2_accounts = []
      self.accounts.each do |acct|
        @@ZONES.each do |zone|
          the_acct = self.use_account(acct)
          the_acct[:host] = "ec2.#{zone}.amazonaws.com"
          all_ec2_accounts << the_acct
        end
      end
      all_ec2_accounts
    end

  end
end
