	SELECT
    s.id AS [ID],
    s.ExternalServiceId AS [ExternalId],
    s.SymServiceId,
    s.Name,
    s.State,
    s.ServiceType,
    s.NetworkTypeId,
    s.OperatorId,
    s.RegionId,
    s.Parent,
    s.ParentServiceId,
    CAST(s.CreateDate AS DATE) AS [CreationDate],
    CAST(s.StartDate AS DATE) AS [StartDate],
    CAST(s.AcceptanceDate AS DATE) AS [AcceptanceDate],
    CAST(s.BillingStartDate AS DATE) AS [BillingStartDate],
    CAST(s.EndDate AS DATE) AS [EndDate],
    CAST(s.ModifiedDate AS DATE) AS [ModifiedDate],
    CAST(s.CancellationDate AS DATE) AS [CancellationDate],
    s.InstallDrop,
    s.Ont,
    cto.CTO,
    cto.CTO_PORT,
    cto.BANDWIDTH_PROFILE,
    cto.SERIAL_NUMBER
FROM 
    multi.service s
LEFT JOIN 
    ( -- Subconsulta para extraer ('CTO', 'CTO_PORT', 'BANDWIDTH_PROFILE', 'SERIAL_NUMBER') usando PIVOT
        SELECT 
            ServiceId,
            CTO,
            CTO_PORT,
            BANDWIDTH_PROFILE,
            SERIAL_NUMBER
        FROM 
            ( -- Extrae CTO, CTO_PORT, BANDWIDTH_PROFILE y SERIAL_NUMBER desde ServiceCharacteristic
                SELECT 
                    ServiceId,
                    Name,
                    Value
                FROM 
                    multi.ServiceCharacteristic
                WHERE 
                    Name IN ('CTO', 'CTO_PORT', 'BANDWIDTH_PROFILE', 'SERIAL_NUMBER')
            ) src
            PIVOT (
                MIN(Value) FOR Name IN ([CTO], [CTO_PORT], [BANDWIDTH_PROFILE], [SERIAL_NUMBER])
            ) AS pivoted
    ) cto 
ON 
    s.Id = cto.ServiceId;