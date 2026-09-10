<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ogc="http://www.opengis.net/ogc" version="1.1.0" xmlns:se="http://www.opengis.net/se" xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.1.0/StyledLayerDescriptor.xsd" xmlns:xlink="http://www.w3.org/1999/xlink">
  <NamedLayer>
    <se:Name>charge_point</se:Name>
    <UserStyle>
      <se:Name>charge_point</se:Name>
      <se:FeatureTypeStyle>
        <se:Rule>
          <se:Name>Ladesäule</se:Name>
          <se:Description>
            <se:Title>Ladesäule</se:Title>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLessThanOrEqualTo>
              <ogc:PropertyName>max_electric_power</ogc:PropertyName>
              <ogc:Literal>22000</ogc:Literal>
            </ogc:PropertyIsLessThanOrEqualTo>
          </ogc:Filter>
          <se:PointSymbolizer>
            <se:Graphic>
              <se:Mark>
                <se:WellKnownName>circle</se:WellKnownName>
                <se:Fill>
                  <se:SvgParameter name="fill">#08a4a7</se:SvgParameter>
                </se:Fill>
                <se:Stroke/>
              </se:Mark>
              <se:Size>7</se:Size>
            </se:Graphic>
          </se:PointSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>Schnellladesäule</se:Name>
          <se:Description>
            <se:Title>Schnellladesäule</se:Title>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsGreaterThan>
              <ogc:PropertyName>max_electric_power</ogc:PropertyName>     
              <ogc:Literal>22000</ogc:Literal>
            </ogc:PropertyIsGreaterThan>
          </ogc:Filter>
          <se:PointSymbolizer>
            <se:Graphic>
              <se:Mark>
                <se:WellKnownName>circle</se:WellKnownName>
                <se:Fill>
                  <se:SvgParameter name="fill">#91FFFF</se:SvgParameter>
                </se:Fill>
                <se:Stroke/>
              </se:Mark>
              <se:Size>7</se:Size>
            </se:Graphic>
          </se:PointSymbolizer>
        </se:Rule>
      </se:FeatureTypeStyle>   
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>