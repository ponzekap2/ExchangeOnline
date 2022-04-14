Set-HostedConnectionFilterPolicy -Identity Default [-AdminDisplayName <"Optional Comment">] [-EnableSafeList <$true | $false>] [-IPAllowList <IPAddressOrRange1,IPAddressOrRange2...>] [-IPBlockList <IPAddressOrRange1,IPAddressOrRange2...>]



Set-HostedConnectionFilterPolicy -Identity Default -IPAllowList @{Add="170.10.132.0/24","170.10.133.0/24","170.10.128.0/24","170.10.129.0/24","170.10.130.0/24","170.10.131.0/24","207.211.31.0/25","207.211.30.0/24","205.139.110.0/24","205.139.111.0/24","216.205.24.0/24","63.128.21.0/24"}