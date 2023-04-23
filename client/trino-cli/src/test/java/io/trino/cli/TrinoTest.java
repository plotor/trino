package io.trino.cli;

import org.junit.Test;

public class TrinoTest
{

    @Test
    public void createCommandLine()
    {
        String[] args = {
                "--server=http://localhost:9084",
                "--user=trino",
                "--catalog=tpch",
                "--schema=sf1",
                "--execute=select * from nation"
        };
        Trino.createCommandLine(new Console()).execute(args);
    }
}
