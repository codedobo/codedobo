
class CodeDoBo
    def setup
        @client.create_table? :main do
            Bignum :server_id, unique: true
            String :language, default: 'en'
            String :prefix, default: '+cdb'
        end
    end
end