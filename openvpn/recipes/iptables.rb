include_recipe "iptables"

iptables_rule "02openvpn" do
    source "iptables.erb"
end
