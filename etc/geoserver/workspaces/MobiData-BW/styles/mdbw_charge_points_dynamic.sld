<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0"
                       xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd"
                       xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <NamedLayer>
    <Name>mdbw_charge_points_dynamic</Name>
    <UserStyle>
      <Title>MobiData BW® - Ladesäulen (nach Status)</Title>
      <FeatureTypeStyle>        
        <Rule>
          <Title>Statische Ladepunkte</Title>          
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsNotEqualTo>
              <ogc:PropertyName>chargepoint_static_count</ogc:PropertyName>
              <ogc:Literal>0</ogc:Literal>
            </ogc:PropertyIsNotEqualTo>
          </ogc:Filter>
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>circle</WellKnownName>
                <Fill>
                  <CssParameter name="fill">#615fdf</CssParameter>
                </Fill>
                <Stroke/>
              </Mark>
              <Size>7</Size>
            </Graphic>
          </PointSymbolizer>
        </Rule>       
        <Rule>
          <Title>Dynamische Ladepunkte</Title>
          <ElseFilter />    
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>circle</WellKnownName>
                <Fill>
                  <CssParameter name="fill">#dfab27</CssParameter>
                </Fill>
                <Stroke/>
              </Mark>
              <Size>7</Size>
            </Graphic>
          </PointSymbolizer>       
        </Rule>
      </FeatureTypeStyle>   
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>