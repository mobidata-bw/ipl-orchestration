<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0.0" xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd">
  <NamedLayer>
    <Name>RadVIS Radnetze Baden-Württemberg</Name>
    <UserStyle>
      <FeatureTypeStyle>
        <Rule>
          <Name>Kommunales Netz</Name>
          <Title>Kommunales Netz</Title>
          <ogc:Filter>
            <ogc:And>
              <ogc:And>
                <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>ext_bw_kommunetz</ogc:PropertyName>
                  <ogc:Literal>1</ogc:Literal>
                </ogc:PropertyIsEqualTo>
                <ogc:Not>
                  <ogc:PropertyIsEqualTo>
                    <ogc:PropertyName>ext_bw_kreisnetz</ogc:PropertyName>
                    <ogc:Literal>1</ogc:Literal>
                  </ogc:PropertyIsEqualTo>
                </ogc:Not>
              </ogc:And>
              <ogc:Not>
                <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>ext_bw_landesnetz</ogc:PropertyName>
                  <ogc:Literal>1</ogc:Literal>
                </ogc:PropertyIsEqualTo>
              </ogc:Not>
            </ogc:And>
          </ogc:Filter>
          <!--<MaxScaleDenominator>100000</MaxScaleDenominator>-->
          <LineSymbolizer>
            <Stroke>
              <CssParameter name="stroke">#0020aa</CssParameter>
              <CssParameter name="stroke-width">2</CssParameter>
            </Stroke>
          </LineSymbolizer>
        </Rule>
        <Rule>
          <Name>Kreisnetz</Name>
          <Title>Kreisnetz</Title>
          <ogc:Filter>
            <ogc:And>
              <ogc:PropertyIsEqualTo>
                <ogc:PropertyName>ext_bw_kreisnetz</ogc:PropertyName>
                <ogc:Literal>1</ogc:Literal>
              </ogc:PropertyIsEqualTo>
              <ogc:Not>
                <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>ext_bw_landesnetz</ogc:PropertyName>
                  <ogc:Literal>1</ogc:Literal>
                </ogc:PropertyIsEqualTo>
              </ogc:Not>
            </ogc:And>
          </ogc:Filter>
          <!--<MaxScaleDenominator>200000</MaxScaleDenominator>-->
          <LineSymbolizer>
            <Stroke>
              <CssParameter name="stroke">#008001</CssParameter>
              <CssParameter name="stroke-width">2</CssParameter>
            </Stroke>
          </LineSymbolizer>
        </Rule>
        <Rule>
          <Name>RadNETZ-BW</Name>
          <Title>RadNETZ-BW</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>ext_bw_landesnetz</ogc:PropertyName>
              <ogc:Literal>1</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <LineSymbolizer>
            <Stroke>
              <CssParameter name="stroke">#FF7F00</CssParameter>
              <CssParameter name="stroke-width">3</CssParameter>
            </Stroke>
          </LineSymbolizer>
        </Rule>
      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>