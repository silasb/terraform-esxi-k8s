[Unit]
Description=Setup Kubernetes Node
#After=network.target
ConditionFirstBoot=true

[Service]
Type=oneshot

ExecStartPre=sudo hostnamectl set-hostname ${type}
ExecStartPre=sudo chmod +x /opt/cluster-init.sh
ExecStart=sudo /opt/cluster-init.sh ${type} ${k8s_version}
RemainAfterExit=true
StandardOutput=journal

[Install]
WantedBy=multi-user.target