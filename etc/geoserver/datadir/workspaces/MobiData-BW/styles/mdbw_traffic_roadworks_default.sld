<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0.0" xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd">
  <NamedLayer>
    <Name>mdbw_traffic_roadworks_default</Name>
    <UserStyle>
      <Title>Arbeitsstelle</Title>
      <Abstract></Abstract>
      <FeatureTypeStyle>
        <Rule>
          <Title>Beide Fahrtrichtungen betroffen</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>direction</ogc:PropertyName>
              <ogc:Literal>BOTH_DIRECTIONS</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <LineSymbolizer>
            <Stroke>
              <CssParameter name="stroke">#ffffff</CssParameter>
              <CssParameter name="stroke-width">5</CssParameter>
              <CssParameter name="stroke-linecap">round</CssParameter>
            </Stroke>
          </LineSymbolizer>
          <LineSymbolizer>
            <Stroke>
              <CssParameter name="stroke">#A93030</CssParameter>
              <CssParameter name="stroke-width">3</CssParameter>
              <CssParameter name="stroke-dasharray">4 2</CssParameter>
            </Stroke>
          </LineSymbolizer>
        </Rule>
        <Rule>
          <Title>Eine Fahrtrichtung betroffen</Title>
          <ogc:Filter>
            <ogc:Not>
              <ogc:PropertyIsEqualTo>
                <ogc:PropertyName>direction</ogc:PropertyName>
                <ogc:Literal>BOTH_DIRECTIONS</ogc:Literal>
              </ogc:PropertyIsEqualTo>
            </ogc:Not>
          </ogc:Filter>
          <LineSymbolizer>
            <Stroke>
              <CssParameter name="stroke">#ffffff</CssParameter>
              <CssParameter name="stroke-width">3</CssParameter>
              <CssParameter name="stroke-linecap">round</CssParameter>
            </Stroke>
            <PerpendicularOffset>2</PerpendicularOffset>
          </LineSymbolizer>
          <LineSymbolizer>
            <Stroke>
              <CssParameter name="stroke">#A93030</CssParameter>
              <CssParameter name="stroke-width">2</CssParameter>
              <CssParameter name="stroke-dasharray">4 2</CssParameter>
            </Stroke>
            <PerpendicularOffset>2</PerpendicularOffset>
          </LineSymbolizer>
        </Rule>
        <Rule>
          <Title>Arbeitsstellen</Title>
          <PointSymbolizer>
            <Geometry>
              <ogc:Function name="interiorPoint">
                <ogc:PropertyName>geometry</ogc:PropertyName>
              </ogc:Function>
            </Geometry>
            <Graphic>
              <Mark>
                <WellKnownName>triangle</WellKnownName>
                <Fill>
                  <CssParameter name="fill">#A93030</CssParameter>
                </Fill>
              </Mark>
              <Size>11</Size>
            </Graphic>
          </PointSymbolizer>
          <PointSymbolizer>
            <Geometry>
              <ogc:Function name="interiorPoint">
                <ogc:PropertyName>geometry</ogc:PropertyName>
              </ogc:Function>
            </Geometry>
            <Graphic>
              <Mark>
                <WellKnownName>triangle</WellKnownName>
                <Fill>
                  <CssParameter name="fill">#ffffff</CssParameter>
                </Fill>
              </Mark>
              <Size>9</Size>
            </Graphic>
          </PointSymbolizer>
        </Rule>
      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>